#!/usr/bin/env bash
# Version: 1.0.0 — declared beta inputs, read as data
# WHY THIS EXISTS
#   The two wording commands share the policy and catalogue grammar. Functions return values
#   and input/error context; callers decide diagnostics, traps and exit status.
# USAGE
#   Source this file, then call beta_load_policy, beta_load_statement and beta_load_notice with
#   explicit paths. Loading defines functions only: no options, traps or I/O change on load.

beta_read_file() {
  beta_input="${1-}"; beta_error=read; beta_bytes=''
  [ "$#" -eq 1 ] && [ -f "$beta_input" ] && [ -r "$beta_input" ] || return 1
  beta_bytes="$(cat "$beta_input" 2> /dev/null)" || return 1
}

# This is a declared-source inspector, not a Swift evaluator. Strings and nested comments are
# opaque before type/member selection. Physical lines survive lexing for the build contract.
# Swift syntax sources:
# https://github.com/swiftlang/swift-book/blob/main/TSPL.docc/LanguageGuide/TheBasics.md#comments
# https://github.com/swiftlang/swift-book/blob/main/TSPL.docc/LanguageGuide/StringsAndCharacters.md#string-literals
beta_swift_value() {
  local kind="${2-}" result=0
  case "$kind" in policy|notice) ;; *) beta_input="${1-}"; beta_error=inspection; return 1;; esac
  beta_read_file "${1-}" || return 1
  beta_value="$(printf '%s\n' "$beta_bytes" | LC_ALL=C awk -v kind="$kind" '
function repeat(c,n, r,i) {r="";for(i=0;i<n;i++)r=r c;return r}
function block_end(s,p, d) {
  d=1;p+=2
  while(p<=length(s)) {
    if(substr(s,p,2)=="/*"){d++;p+=2}
    else if(substr(s,p,2)=="*/"){d--;p+=2;if(!d)return p}
    else p++
  }
  lexical_bad=1;return p
}
function quote_at(s,p, h,q) {
  h=0;while(substr(s,p+h,1)=="#")h++
  if(substr(s,p+h,1)!="\"")return 0
  q=(substr(s,p+h,3)=="\"\"\""?3:1)
  return quote_end(s,p,h,q)
}
function expression_end(s,p, d,e,c,j) {
  d=1
  while(p<=length(s)) {
    e=quote_at(s,p);if(e){p=e;continue}
    if(substr(s,p,2)=="/*"){p=block_end(s,p);continue}
    if(substr(s,p,2)=="//"){j=index(substr(s,p),"\n");p=(j?p+j:length(s)+1);continue}
    c=substr(s,p++,1)
    if(c=="(")d++
    if(c==")"){d--;if(!d)return p}
  }
  lexical_bad=1;return p
}
function quote_end(s,start,h,q, p,closing,escape) {
  closing=repeat("\"",q) repeat("#",h);escape="\\" repeat("#",h);p=start+h+q
  while(p<=length(s)) {
    if(substr(s,p,length(closing))==closing)return p+length(closing)
    if(substr(s,p,length(escape))==escape) {
      p+=length(escape)
      if(substr(s,p,1)=="(")p=expression_end(s,p+1);else p++
    } else p++
  }
  lexical_bad=1;return p
}
function emit(text,line,endline,form,value) {
  tokens[++nt]=text;lines[nt]=line;ends[nt]=endline;forms[nt]=form;values[nt]=value
}
function tokenize(s, p,line,c,j,e,part,n,h,q,form) {
  p=1;line=1
  while(p<=length(s)) {
    c=substr(s,p,1)
    if(c=="\n"){line++;p++;continue}
    if(c ~ /[ \t\r]/){p++;continue}
    if(substr(s,p,2)=="//"){j=index(substr(s,p),"\n");p=(j?p+j-1:length(s)+1);continue}
    if(substr(s,p,2)=="/*") {
      e=block_end(s,p);part=substr(s,p,e-p);n=gsub(/\n/,"",part);line+=n;p=e;continue
    }
    e=quote_at(s,p)
    if(e) {
      part=substr(s,p,e-p);h=0;while(substr(part,h+1,1)=="#")h++
      q=(substr(part,h+1,3)=="\"\"\""?3:1)
      form=(h?"raw":q==3?"triple":"ordinary")
      n=gsub(/\n/,"\n",part)
      emit("STRING",line,line+n,form,substr(part,h+q+1,length(part)-2*h-2*q))
      line+=n;p=e;continue
    }
    if(c ~ /[A-Za-z_]/) {
      j=p+1;while(substr(s,j,1) ~ /[A-Za-z0-9_]/ && j<=length(s))j++
      emit(substr(s,p,j-p),line,line,"","");p=j;continue
    }
    emit(c,line,line,"","");p++
  }
}
function access(t) {return t ~ /^(package|public|internal|private|fileprivate)$/}
function trim_value(s) {sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);return s}
function next_member(t) {return t=="" || t==";" || t ~ /^(package|public|internal|private|fileprivate|static|let|var|func|case|enum|struct|class)$/}
function inspect(typename,member, i,j,depth,open,closing,count,conditional,start,k,value,valid,types) {
  depth=0
  for(i=1;i<=nt;i++) {
    if(depth==0 && tokens[i] ~ /^(enum|struct|class)$/ && tokens[i+1]==typename) {
      types++;j=i+2;while(j<=nt && tokens[j]!="{")j++
      if(j>nt){bad=1;continue}
      open=j;depth=1
      for(j=open+1;j<=nt;j++) {
        if(tokens[j]=="{")depth++
        if(tokens[j]=="}"){depth--;if(!depth)break}
        if(depth==1 && tokens[j]!="{") {
          body[++nb]=tokens[j];bl[nb]=lines[j];be[nb]=ends[j];bf[nb]=forms[j];bv[nb]=values[j]
        }
      }
      if(depth)bad=1
      i=j;depth=0;continue
    }
    if(tokens[i]=="{")depth++
    if(tokens[i]=="}")depth--
  }
  if(types!=1 || lexical_bad || bad)return ""
  for(i=1;i<=nb;i++) {
    if(body[i]=="#" && body[i+1]=="if")conditional++
    if(body[i]=="#" && body[i+1]=="endif")conditional--
    if(body[i] !~ /^(let|var)$/ || body[i+1]!=member)continue
    count++;valid=1;start=i-1
    if(body[i]!="let" || body[start]!="static" || conditional)valid=0
    if(access(body[start-1]))start--
    k=i+2
    if(body[k]==":") {if(body[k+1]!=(kind=="policy"?typename:"String"))valid=0;k+=2}
    if(body[k]!="=")valid=0
    k++
    if(kind=="policy") {
      if(body[k]!="." || body[k+1] !~ /^(atOpen|followed)$/)valid=0
      value=body[k+1];k++
      for(j=start;j<=k;j++)if(bl[j]!=bl[i])valid=0
    } else {
      if(body[k]!="STRING" || bf[k]!="ordinary" || bl[k]!=be[k])valid=0
      value=bv[k]
      # Escapes would make a raw fixed-string hit differ from the displayed value.
      if(index(value,"\\") || !length(trim_value(value)))valid=0
      for(j=start;j<k;j++)if(bl[j]!=bl[i])valid=0
    }
    if(!next_member(body[k+1]))valid=0
    if(!valid)bad=1
  }
  if(count!=1 || bad)return ""
  return value
}
{document=document $0 "\n"}
END {
  tokenize(document)
  value=(kind=="policy"?inspect("GitReadPolicy","build"):inspect("GitSentences","readAtOpen"))
  if(!length(value))exit 3
  print value
}
' 2> /dev/null)" || result=$?
  case "$result" in
    0) return 0;;
    3) beta_error="$kind"; return 1;;
    *) beta_error=inspection; return 1;;
  esac
}

beta_load_policy() {
  beta_policy=''
  beta_swift_value "${1-}" policy || return 1
  beta_policy="$beta_value"
}

beta_load_statement() {
  local mode="${2-}" result=0 record
  beta_wording=''; beta_statement_present=0
  beta_read_file "${1-}" || return 1
  case "$mode" in atOpen|followed) ;; *) beta_error=canonical; return 1;; esac
  record="$(printf '%s\n' "$beta_bytes" | LC_ALL=C awk -v mode="$mode" '
function trim(s) {sub(/^[ \t]+/,"",s);sub(/[ \t\r]+$/,"",s);return s}
{
  line=$0;sub(/\r$/,"",line)
  if(comment) {end=index(line,"-->");if(!end)next;line=substr(line,end+3);comment=0}
  while((start=index(line,"<!--"))) {
    end=index(substr(line,start+4),"-->")
    if(!end){line=substr(line,1,start-1);comment=1;break}
    line=substr(line,1,start-1) substr(line,start+end+6)
  }
  clean=trim(line);marker=substr(clean,1,1);run=0
  if(marker=="`" || marker=="~")while(substr(clean,run+1,1)==marker)run++
  if(fence) {if(marker==fence && run>=fence_length && substr(clean,run+1)~/^[ \t]*$/)fence="";next}
  if(run>=3){fence=marker;fence_length=run;next}
  if(line~/^#+ /) {section=(line~/^### Standing sentences[ \t]*$/);if(section)sections++;table=0}
  if(section && line~/^\| What it states[ \t]*\|[ \t]*The wording[ \t]*\|[ \t]*$/){table=1;tables++;next}
  if(!section || !table || line!~/^\|/)next
  cells=substr(line,2);bar=index(cells,"|");if(!bar)next
  label=trim(substr(cells,1,bar-1));sub(/ \(.*/,"",label)
  if(label!="The beta\047s Git view")next
  count++;cell=trim(substr(cells,bar+1))
  if(substr(cell,1,3)!="**\""){bad=1;next}
  cell=substr(cell,4);end=index(cell,"\"**")
  if(!end || cell!~/\|[ \t]*$/){bad=1;next}
  wording=substr(cell,1,end-1)
  if(!length(trim(wording)))bad=1
}
END {
  if(sections!=1 || tables!=1 || count>1 || bad || (!count && mode=="atOpen"))exit 3
  if(count)print "1\t" wording;else print "0"
}
' 2> /dev/null)" || result=$?
  case "$result" in
    0) ;;
    3) beta_error=canonical; return 1;;
    *) beta_error=inspection; return 1;;
  esac
  case "$record" in
    0) return 0;;
    1$'\t'*) beta_statement_present=1; beta_wording="${record#*$'\t'}";;
    *) beta_error=inspection; return 1;;
  esac
}

beta_load_notice() {
  beta_notice=''
  beta_swift_value "${1-}" notice || return 1
  beta_notice="$beta_value"
}

beta_check_agreement() {
  if [ "$beta_statement_present" -eq 1 ] && [ "$beta_notice" != "$beta_wording" ]; then
    beta_error=agreement
    return 1
  fi
}
