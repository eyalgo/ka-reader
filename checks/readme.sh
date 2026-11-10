#!/usr/bin/env bash
# Version: 1.0.0 — local README wording and image-source inspection
#
# WHY THIS EXISTS
#   docs/nfdr.md QC-44 fixes whole literal wordings, not fragments. CONTENT owns them. Image
#   declarations must name repository files even when a renderer would choose another source.
# USAGE
#   checks/readme.sh, from the product root. No argument or script-owned environment override.
#   0: all checks completed and passed; 1: findings, failed inspection or HUP/INT/TERM; 2: usage.
# NO FILE IS WRITTEN
#   Captures and pipes keep intermediate data in memory. Bash 3.2 here-documents and here-strings
#   can create files, so neither is used. Images are inspected as path metadata, never opened.
set -euo pipefail

reported=0
trap 'status=$?; if [ "$status" -ne 0 ] && [ "$reported" -eq 0 ]; then printf "%s\n" "readme.sh: could not complete the local check. Check that the required documents and Git checkout are readable and the local text tools run, then run checks/readme.sh from the product root." >&2; exit 1; fi' EXIT
interrupted() {
  reported=1
  printf 'readme.sh: interrupted by %s; the check did not complete. Run checks/readme.sh from the product root to check again.\n' "$1" >&2
  exit 1
}
trap 'interrupted HUP' HUP
trap 'interrupted INT' INT
trap 'interrupted TERM' TERM
if [ "$#" -ne 0 ]; then
  reported=1
  printf '%s\n' 'Usage: checks/readme.sh' >&2
  exit 2
fi

# --- required documents and the canonical set ---
for file in docs/CONTENT.md README.md SECURITY.md; do
  if [ ! -f "$file" ] || [ ! -r "$file" ]; then
    reported=1
    printf 'readme.sh: %s: cannot read required input. Make this file readable, then run checks/readme.sh from the product root.\n' "$file" >&2
    exit 1
  fi
  if bytes="$(cat "$file" 2> /dev/null)"; then
    case "$file" in docs/CONTENT.md) content="$bytes";; README.md) readme="$bytes";; esac
  else
    reported=1
    printf 'readme.sh: %s: cannot read required input. Make this file readable, then run checks/readme.sh from the product root.\n' "$file" >&2
    exit 1
  fi
done
canonical_status=0
canonical="$(printf '%s\n' "$content" | LC_ALL=C awk 'function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
function identity(label) {
  sub(/ \(.*/, "", label)
  if (label == "Read-only — the product\047s defining promise") return 1
  if (label == "The network") return 2
  if (label == "Before 1.0.0") return 3
  if (label == "The support posture") return 4
  if (label == "Archiving") return 5
  if (label == "The accessibility posture, on the README below its first screen") return 6
  return 0
}
BEGIN {
  labels[1]="Read-only — the product\047s defining promise"
  labels[2]="The network"; labels[3]="Before 1.0.0"; labels[4]="The support posture"
  labels[5]="Archiving"; labels[6]="The accessibility posture, on the README below its first screen"
}
{ sub(/\r$/, "") }
/^#+ / { section = ($0 ~ /^### Standing sentences[ \t]*$/) }
section && /^\| What it states[ \t]*\|[ \t]*The wording[ \t]*\|[ \t]*$/ { table=1; next }
section && table && /^\|/ {
  text=substr($0,2); bar=index(text,"|"); if (!bar) next
  label=trim(substr(text,1,bar-1)); id=identity(label); if (!id) next
  count[id]++; order[++rows]=id
  cell=trim(substr(text,bar+1)); start=index(cell,"**\"")
  if (start != 1) { malformed[id]=1; next }
  cell=substr(cell,4); end=index(cell,"\"**")
  if (!end || cell !~ /\|[ \t]*$/) { malformed[id]=1; next }
  words[id]=substr(cell,1,end-1)
}
END {
  if (!table) { print "readme.sh: docs/CONTENT.md: no standing-sentences table was found. Restore the table, then run checks/readme.sh from the product root."; exit 3 }
  for (id=1;id<=6;id++) {
    if (!count[id]) { printf "readme.sh: docs/CONTENT.md: required standing-sentence row is missing: %s. Restore this row, then run checks/readme.sh from the product root.\n", labels[id]; bad=1 }
    else if (count[id]>1) { printf "readme.sh: docs/CONTENT.md: required standing-sentence row occurs more than once: %s. Keep the canonical row once, then run checks/readme.sh from the product root.\n", labels[id]; bad=1 }
    else if (malformed[id]) { printf "readme.sh: docs/CONTENT.md: could not read the complete wording of required standing-sentence row: %s. Check this row'"'"'s quoted wording and table markup, then run checks/readme.sh from the product root.\n", labels[id]; bad=1 }
    else if (!length(trim(words[id]))) { printf "readme.sh: docs/CONTENT.md: required standing-sentence row has no wording: %s. Restore its complete wording, then run checks/readme.sh from the product root.\n", labels[id]; bad=1 }
  }
  if (bad) exit 3
  for (n=1;n<=rows;n++) { id=order[n]; print id "\t" words[id] }
}
' 2> /dev/null)" || canonical_status=$?
if [ "$canonical_status" -ne 0 ]; then
  reported=1
  if [ "$canonical_status" -eq 3 ] && [ -n "$canonical" ]; then
    printf '%s\n' "$canonical" >&2
  else
    printf '%s\n' 'readme.sh: docs/CONTENT.md: could not complete the standing-sentence inspection. Check that this file is readable and the local text tools run, then run checks/readme.sh from the product root.' >&2
  fi
  exit 1
fi
findings=0
# A complete pattern and a completed read are both required: -q can hide a late read error.
while IFS=$'\t' read -r identity wording; do
  files=(README.md)
  [ "$identity" != 4 ] || files+=(SECURITY.md)
  for file in "${files[@]}"; do
    comparison_status=0
    grep -F -- "$wording" "$file" > /dev/null 2> /dev/null || comparison_status=$?
    case "$comparison_status" in
      0) ;;
      1) printf 'readme.sh: %s: missing standing sentence: %s\n' "$file" "$wording" >&2; findings=1;;
      *) reported=1; printf 'readme.sh: %s: could not complete the standing-sentence comparison. Check that this file is readable and grep runs, then run checks/readme.sh from the product root.\n' "$file" >&2; exit 1;;
    esac
  done
done < <(printf '%s\n' "$canonical")

# --- the local index, once; hexadecimal records preserve every filename byte ---
index_status=0
tracked="$(git ls-files --cached -z 2> /dev/null | LC_ALL=C od -An -v -tx1 | LC_ALL=C awk '{ for (i=1;i<=NF;i++) { if ($i=="00") { print name; name="" } else name=name $i } } END { if (length(name)) exit 1 }')" || index_status=$?
if [ "$index_status" -ne 0 ]; then
  reported=1
  printf '%s\n' "readme.sh: could not read Git's tracked file list. Run checks/readme.sh from the product root with Git available and the checkout readable." >&2
  exit 1
fi
root="$(pwd -P)"

path_is_tracked() {
  local encoded tracked="$2"
  encoded="$(printf '%s' "$1" | LC_ALL=C od -An -v -tx1 | tr -d ' \n')" || return 2
  case $'\n'"$tracked"$'\n' in *$'\n'"$encoded"$'\n'*) return 0;; *) return 1;; esac
}

# Walk links before .., and reject an outward position immediately: a later component must not
# bring an outside traversal back inside (docs/nfdr.md QC-44's repository-file condition).
repository_file() {
  local reference="$1" pending="$1" root="$2" tracked="$3" component candidate target normal normal_status=0 links=0
  local current="$root"
  case "$reference" in ''|/*) return 1;; esac
  normal="$(printf '%s\n' "$reference" | LC_ALL=C awk -F/ '{ n=0; for(i=1;i<=NF;i++) { if($i==""||$i==".")continue; if($i=="..") {if(!n)exit 3;n--}else parts[++n]=$i } for(i=1;i<=n;i++)printf "%s%s",(i>1?"/":""),parts[i] }')" || normal_status=$?
  case "$normal_status" in 0) ;; 3) return 1;; *) return 2;; esac
  path_is_tracked "$normal" "$tracked" || return "$?"
  while [ -n "$pending" ]; do
    case "$pending" in */*) component="${pending%%/*}"; pending="${pending#*/}";; *) component="$pending"; pending='';; esac
    case "$component" in
      ''|.) continue;;
      ..) [ "$current" != "$root" ] || return 1; current="${current%/*}"; continue;;
    esac
    candidate="$current/$component"
    if [ -L "$candidate" ]; then
      links=$((links+1)); [ "$links" -le 40 ] || return 1
      target="$(readlink "$candidate" 2> /dev/null)" || return 2
      [ -n "$target" ] || return 2
      case "$target" in
        "$root"/*) target="${target#"$root"/}"; current="$root";;
        /*) return 1;;
      esac
      if [ -n "$pending" ]; then pending="$target/$pending"; else pending="$target"; fi
    else
      [ -e "$candidate" ] || return 1
      if [ -n "$pending" ]; then [ -d "$candidate" ] || return 1; fi
      current="$candidate"
    fi
  done
  [ -f "$current" ] || return 1
  path_is_tracked "${current#"$root"/}" "$tracked"
}

unhex() {
  local bytes="$1" escapes=''
  while [ -n "$bytes" ]; do escapes="$escapes\\x${bytes:0:2}"; bytes="${bytes:2}"; done
  printf '%b' "$escapes"
}

# --- prose image declarations; reference definitions are collected before uses resolve ---
# HTML character names are encoded data from Python's standard html.entities.html5 table,
# including legacy attribute spellings; no Python runs here. Source and interpretation:
# https://docs.python.org/3/library/html.entities.html#html.entities.html5
# https://html.spec.whatwg.org/multipage/named-characters.html#named-character-references
# Markdown references and image destinations: https://spec.commonmark.org/0.31.2/#images
image_status=0
image_records="$(printf '%s\n' "$readme" | LC_ALL=C awk 'function hex_byte(c) { return sprintf("%02x", byte[c]) }
function as_hex(s, result,i) { result=""; for(i=1;i<=length(s);i++) result=result hex_byte(substr(s,i,1)); return (result==""?"-":result) }
function from_hex(s, result,i) { result=""; for(i=1;i<=length(s);i+=2) result=result sprintf("%c",hex_number(substr(s,i,2))); return result }
function hex_number(s, n,i,c) { n=0; s=tolower(s); for(i=1;i<=length(s);i++){c=index("0123456789abcdef",substr(s,i,1))-1;if(c<0)return -1;n=n*16+c}return n }
function utf8(n) {
  if(n<1 || n>1114111 || (n>=55296&&n<=57343)) n=65533
  if(n<128)return sprintf("%c",n)
  if(n<2048)return sprintf("%c%c",192+int(n/64),128+n%64)
  if(n<65536)return sprintf("%c%c%c",224+int(n/4096),128+int(n/64)%64,128+n%64)
  return sprintf("%c%c%c%c",240+int(n/262144),128+int(n/4096)%64,128+int(n/64)%64,128+n%64)
}
function unescape(s, result,i,c,nextc) {
  result=""
  for(i=1;i<=length(s);i++) {
    c=substr(s,i,1); nextc=substr(s,i+1,1)
    if(c=="\\" && nextc ~ /[!"#$%&\047()*+,\-.\/:;<=>?@\[\]\\^_`{|}~ ]/) { result=result nextc; i++ }
    else result=result c
  }
  return result
}
function entities(s,attribute,keep_map, result,i,j,remaining,token,name,value,number,consumed,size,output_start) {
  result="";i=1
  if(keep_map){split("",entity_begin);split("",entity_end)}
  while(i<=length(s)) {
    consumed=1;value=substr(s,i,1)
    if(value=="&") {
      remaining=substr(s,i)
      if(match(remaining,/^&#([xX][0-9A-Fa-f]+|[0-9]+);?/)) {
        token=substr(remaining,1,RLENGTH)
        if(attribute || substr(token,length(token),1)==";") {
          consumed=length(token);name=substr(token,3);sub(/;$/,"",name)
          if(substr(name,1,1) ~ /[xX]/)number=hex_number(substr(name,2));else number=name+0
          if(number in numeric)number=numeric[number]
          value=utf8(number)
        }
      } else {
        size=length(remaining)-1;if(size>entity_max)size=entity_max
        for(j=size;j>0;j--) {
          name=substr(remaining,2,j)
          if(!(name in entity))continue
          if(substr(name,length(name),1)!=";") {
            if(!attribute || substr(remaining,j+2,1) ~ /[A-Za-z0-9=]/)continue
          }
          consumed=j+1;value=from_hex(entity[name]);break
        }
      }
    }
    output_start=length(result)
    if(keep_map)for(j=1;j<=length(value);j++){entity_begin[output_start+j]=i;entity_end[output_start+j]=i+consumed-1}
    result=result value;i+=consumed
  }
  return result
}
function address(s,attribute,already_decoded, result,pair,i,c) {
  invalid=0; if(!attribute)s=unescape(s); if(!already_decoded)s=entities(s,attribute,0)
  sub(/[?#].*$/,"",s)
  result=""
  for(i=1;i<=length(s);i++) {
    c=substr(s,i,1)
    if(c=="%" && substr(s,i+1,2) ~ /^[0-9A-Fa-f][0-9A-Fa-f]$/) {
      pair=hex_number(substr(s,i+1,2)); if(pair==0)invalid=1
      result=result sprintf("%c",pair); i+=2
    } else result=result c
  }
  gsub(/\\/,"/",result)
  if(result ~ /[\001-\037\177]/ || result ~ /^[A-Za-z][A-Za-z0-9+.-]*:/)invalid=1
  return result
}
function label(s) { s=entities(unescape(s)); gsub(/[ \t\r\n]+/," ",s); sub(/^ /,"",s);sub(/ $/,"",s);return tolower(s) }
function code_span_end(s,start, n,m,j) {
  n=0;while(substr(s,start+n,1)=="`")n++
  j=start+n
  while(j<=length(s)) {
    if(substr(s,j,2)=="\n\n")return 0
    if(substr(s,j,1)!="`"){j++;continue}
    m=0;while(substr(s,j+m,1)=="`")m++
    if(m==n)return j+m
    j+=m
  }
  return 0
}
function filtered_prose(s, result,i,j,end,line,indent,tail,marker,run,fence,fence_length,c,fragment) {
  i=1;result="";fence=""
  while(i<=length(s)) {
    if(i==1 || substr(s,i-1,1)=="\n") {
      j=index(substr(s,i),"\n");end=(j?i+j:i+length(s))
      line=substr(s,i,end-i);match(line,/^ */);indent=RLENGTH
      tail=substr(line,indent+1);marker=substr(tail,1,1);run=0
      if(marker=="`"||marker=="~")while(substr(tail,run+1,1)==marker)run++
      if(fence) {
        if(indent<=3&&marker==fence&&run>=fence_length&&substr(tail,run+1)~/^[ \t\r\n]*$/)fence=""
        result=result "\n";i=end;continue
      }
      if(indent<=3&&run>=3){fence=marker;fence_length=run;result=result "\n";i=end;continue}
      if(indent>=4||line~/^\t/){result=result "\n";i=end;continue}
    }
    c=substr(s,i,1)
    if(c=="\\"){result=result substr(s,i,2);i+=2;continue}
    if(c=="`") {
      end=code_span_end(s,i)
      if(end){fragment=substr(s,i,end-i);gsub(/[^\n]/," ",fragment);result=result fragment;i=end;continue}
    }
    if(substr(s,i,4)=="<!--") {
      j=index(substr(s,i+4),"-->");if(!j)return result
      fragment=substr(s,i,j+6);gsub(/[^\n]/," ",fragment);result=result fragment;i+=j+6;continue
    }
    # Keep a tag whole: indentation inside a multi-line attribute is not an indented code block.
    if(c=="<"&&substr(s,i)~/^<\/?[A-Za-z]/) {
      end=tag_end(s,i)
      if(end){result=result substr(s,i,end-i+1);i=end+1;continue}
    }
    result=result c;i++
  }
  return result
}
function bracket_end(s,start, depth,i,c) {
  depth=1
  for(i=start+1;i<=length(s);i++) {
    c=substr(s,i,1);if(c=="\\"){i++;continue}
    if(c=="[")depth++
    if(c=="]"){depth--;if(!depth)return i}
  }
  return 0
}
function destination(s,start, i,c,depth,begin) {
  destination_valid=0;destination_source="";i=start
  while(substr(s,i,1) ~ /[ \t\n]/ && i<=length(s))i++
  destination_start=i
  if(substr(s,i,1)=="<") {
    begin=++i
    for(;i<=length(s);i++) {
      c=substr(s,i,1);if(c=="\\"){i++;continue}
      if(c==">"){destination_source=substr(s,begin,i-begin);destination_end=i+1;destination_valid=1;return}
      if(c=="\n")return
    }
    return
  }
  begin=i;depth=0
  for(;i<=length(s);i++) {
    c=substr(s,i,1)
    if(c=="\\"){i++;continue}
    if(c=="(")depth++
    else if(c==")"){if(!depth)break;depth--}
    else if(c ~ /[ \t\n]/ && !depth)break
  }
  if(depth)return
  destination_source=substr(s,begin,i-begin);destination_end=i;destination_valid=1
}
function inline_end(s,start, i,c,quote) {
  i=start;while(substr(s,i,1) ~ /[ \t\n]/ && i<=length(s))i++
  c=substr(s,i,1)
  if(c=="\"" || c=="\047" || c=="(") {
    quote=(c=="("?")":c);i++
    while(i<=length(s)){c=substr(s,i++,1);if(c=="\\"){i++;continue}if(c==quote)break}
    while(substr(s,i,1) ~ /[ \t\n]/ && i<=length(s))i++
  }
  return (substr(s,i,1)==")"?i:0)
}
function source(raw,attribute,logical) { kind[++uses]="S"; original[uses]=raw;html_attribute[uses]=attribute;if(length(logical))logical_source[uses]=logical }
function reference(raw,id) {kind[++uses]="R";original[uses]=raw;reference_id[uses]=label(id)}
function srcset(s, i,c,raw,begin,depth,input,finish) {
  input=s;s=entities(s,1,1);i=1
  while(i<=length(s)) {
    while(substr(s,i,1) ~ /[ \t\r\n,]/ && i<=length(s))i++
    begin=i
    while(i<=length(s) && substr(s,i,1) !~ /[ \t\r\n]/) {
      if(substr(s,i,1)=="," && tolower(substr(s,begin,5))!="data:")break
      i++
    }
    raw=substr(s,begin,i-begin);sub(/,+$/,"",raw)
    if(length(raw)){finish=begin+length(raw)-1;source(substr(input,entity_begin[begin],entity_end[finish]-entity_begin[begin]+1),1,raw)}
    if(substr(s,i,1)==","){i++;continue}
    depth=0
    while(i<=length(s)) {c=substr(s,i++,1);if(c=="(")depth++;if(c==")")depth--;if(c==","&&!depth)break}
  }
}
function tag_end(s,start, i,c,quote) {
  quote=""
  for(i=start+1;i<=length(s);i++) {
    c=substr(s,i,1)
    if(quote){if(c==quote)quote=""}
    else if(c=="\""||c=="\047")quote=c
    else if(c==">")return i
  }
  return 0
}
function html(tag, name,closing,i,c,attribute,value,begin,quote,attr) {
  if(!match(tag,/^<\/?[A-Za-z][A-Za-z0-9:-]*/))return
  name=tolower(substr(tag,1,RLENGTH));closing=(substr(name,2,1)=="/");sub(/^<\/?/,"",name)
  i=RLENGTH+1
  if(name=="picture"){if(closing){if(picture)picture--}else picture++;return}
  if(closing || !(name=="img"||name=="image"||name=="input"||(name=="source"&&picture)))return
  split("",attr)
  while(i<=length(tag)) {
    c=substr(tag,i,1)
    if(c ~ /[ \t\r\n\/>]/){i++;continue}
    if(!match(substr(tag,i),/^[A-Za-z_:][A-Za-z0-9_:.-]*/)){i++;continue}
    attribute=tolower(substr(tag,i,RLENGTH));i+=RLENGTH
    while(substr(tag,i,1) ~ /[ \t\r\n]/ && i<=length(tag))i++
    if(substr(tag,i,1)!="=")continue
    i++;while(substr(tag,i,1) ~ /[ \t\r\n]/ && i<=length(tag))i++
    quote=substr(tag,i,1)
    if(quote=="\""||quote=="\047") {begin=++i;while(i<=length(tag)&&substr(tag,i,1)!=quote)i++;value=substr(tag,begin,i-begin);i++}
    else {begin=i;while(i<=length(tag)&&substr(tag,i,1)!~/[ \t\r\n>]/)i++;value=substr(tag,begin,i-begin)}
    if(!(attribute in attr))attr[attribute]=value
  }
  if(name=="input"&&tolower(attr["type"])!="image")return
  if(name=="img" && !("src" in attr) && (!("srcset" in attr) || attr["srcset"]~/^[ \t\r\n]*$/))source("")
  if("src" in attr)source(attr["src"],1)
  if("srcset" in attr)srcset(attr["srcset"])
  if(name=="image") {if("href" in attr)source(attr["href"],1);if("xlink:href" in attr)source(attr["xlink:href"],1)}
}
function definition_end(s,after_url, first_end,j,c,quote) {
  first_end=index(substr(s,after_url),"\n")
  first_end=(first_end?after_url+first_end: length(s)+1)
  j=after_url
  while(substr(s,j,1) ~ /[ \t]/ && j<=length(s))j++
  if(substr(s,j,1)=="\n") {
    j++;while(substr(s,j,1) ~ /[ \t]/ && j<=length(s))j++
    c=substr(s,j,1)
    if(c!="\""&&c!="\047"&&c!="(")return first_end
  }
  c=substr(s,j,1)
  if(c=="" || c=="\n")return first_end
  if(c!="\""&&c!="\047"&&c!="(")return 0
  quote=(c=="("?")":c);j++
  for(;j<=length(s);j++) {
    c=substr(s,j,1);if(c=="\\"){j++;continue}
    if(c==quote)break
  }
  if(j>length(s))return 0
  j++;while(substr(s,j,1) ~ /[ \t]/ && j<=length(s))j++
  if(j<=length(s)&&substr(s,j,1)!="\n")return 0
  return j+1
}
function definitions(s, lines,n,i,line,start,end,id,offset,padding,newlines,finish,consumed_until,line_start) {
  n=split(s,lines,"\n");offset=0
  for(i=1;i<=n;i++) {
    line=lines[i];line_start=offset+1;start=line_start;offset+=length(line)+1
    if(start<consumed_until)continue
    match(line,/^ */);start+=RLENGTH
    if(RLENGTH>3 || substr(s,start,1)!="[")continue
    end=bracket_end(s,start)
    if(!end || substr(s,end+1,1)!=":")continue
    id=label(substr(s,start+1,end-start-1));destination(s,end+2)
    padding=substr(s,end+2,destination_start-end-2);newlines=gsub(/\n/,"",padding)
    if(!destination_valid || !length(destination_source) || newlines>1)continue
    finish=definition_end(s,destination_end);if(!finish)continue
    if(!(id in defined)){defined[id]=1;definitions_url[id]=destination_source}
    definition_skip[line_start]=finish;consumed_until=finish
  }
}
function images(s, i,end,after,closing_at,label_text,id,finish,raw,c) {
  definitions(s)
  i=1
  while(i<=length(s)) {
    if(i in definition_skip){i=definition_skip[i];continue}
    c=substr(s,i,1)
    if(c=="\\"){i+=2;continue}
    if(c=="<") {end=tag_end(s,i);if(end){html(substr(s,i,end-i+1));i=end+1;continue}}
    if(substr(s,i,2)!="!["){i++;continue}
    end=bracket_end(s,i+1);if(!end){i+=2;continue}
    label_text=substr(s,i+2,end-i-2);after=end+1
    if(substr(s,after,1)=="(") {
      destination(s,after+1)
      if(destination_valid){raw=destination_source;finish=inline_end(s,destination_end);if(finish){source(raw);i=finish+1;continue}}
      i=end+1;continue
    }
    if(substr(s,after,1)=="[") {
      closing_at=bracket_end(s,after)
      if(closing_at){id=substr(s,after+1,closing_at-after-1);if(!length(id))id=label_text;reference(substr(s,i,closing_at-i+1),id);i=closing_at+1;continue}
    }
    reference(substr(s,i,end-i+1),label_text);i=end+1
  }
}
BEGIN {
  for(i=1;i<256;i++)byte[sprintf("%c",i)]=i
  count=split("AElig:c386 AElig;:c386 AMP:26 AMP;:26 Aacute:c381 Aacute;:c381 Abreve;:c482 Acirc:c382 Acirc;:c382 Acy;:d090 Afr;:f09d9484 Agrave:c380 Agrave;:c380 Alpha;:ce91 Amacr;:c480 And;:e2a993 Aogon;:c484 Aopf;:f09d94b8 ApplyFunction;:e281a1 Aring:c385 Aring;:c385 Ascr;:f09d929c Assign;:e28994 Atilde:c383 Atilde;:c383 Auml:c384 Auml;:c384 Backslash;:e28896 Barv;:e2aba7 Barwed;:e28c86 Bcy;:d091 Because;:e288b5 Bernoullis;:e284ac Beta;:ce92 Bfr;:f09d9485 Bopf;:f09d94b9 Breve;:cb98 Bscr;:e284ac Bumpeq;:e2898e CHcy;:d0a7 COPY:c2a9 COPY;:c2a9 Cacute;:c486 Cap;:e28b92 CapitalDifferentialD;:e28585 Cayleys;:e284ad Ccaron;:c48c Ccedil:c387 Ccedil;:c387 Ccirc;:c488 Cconint;:e288b0 Cdot;:c48a Cedilla;:c2b8 CenterDot;:c2b7 Cfr;:e284ad Chi;:cea7 CircleDot;:e28a99 CircleMinus;:e28a96 CirclePlus;:e28a95 CircleTimes;:e28a97 ClockwiseContourIntegral;:e288b2 CloseCurlyDoubleQuote;:e2809d CloseCurlyQuote;:e28099 Colon;:e288b7 Colone;:e2a9b4 Congruent;:e289a1 Conint;:e288af ContourIntegral;:e288ae Copf;:e28482 Coproduct;:e28890 CounterClockwiseContourIntegral;:e288b3 Cross;:e2a8af Cscr;:f09d929e Cup;:e28b93 CupCap;:e2898d DD;:e28585 DDotrahd;:e2a491 DJcy;:d082 DScy;:d085 DZcy;:d08f Dagger;:e280a1 Darr;:e286a1 Dashv;:e2aba4 Dcaron;:c48e Dcy;:d094 Del;:e28887 Delta;:ce94 Dfr;:f09d9487 DiacriticalAcute;:c2b4 DiacriticalDot;:cb99 DiacriticalDoubleAcute;:cb9d DiacriticalGrave;:60 DiacriticalTilde;:cb9c Diamond;:e28b84 DifferentialD;:e28586 Dopf;:f09d94bb Dot;:c2a8 DotDot;:e2839c DotEqual;:e28990 DoubleContourIntegral;:e288af DoubleDot;:c2a8 DoubleDownArrow;:e28793 DoubleLeftArrow;:e28790 DoubleLeftRightArrow;:e28794 DoubleLeftTee;:e2aba4 DoubleLongLeftArrow;:e29fb8 DoubleLongLeftRightArrow;:e29fba DoubleLongRightArrow;:e29fb9 DoubleRightArrow;:e28792 DoubleRightTee;:e28aa8 DoubleUpArrow;:e28791 DoubleUpDownArrow;:e28795 DoubleVerticalBar;:e288a5 DownArrow;:e28693 DownArrowBar;:e2a493 DownArrowUpArrow;:e287b5 DownBreve;:cc91 DownLeftRightVector;:e2a590 DownLeftTeeVector;:e2a59e DownLeftVector;:e286bd DownLeftVectorBar;:e2a596 DownRightTeeVector;:e2a59f DownRightVector;:e28781 DownRightVectorBar;:e2a597 DownTee;:e28aa4 DownTeeArrow;:e286a7 Downarrow;:e28793 Dscr;:f09d929f Dstrok;:c490 ENG;:c58a ETH:c390 ETH;:c390 Eacute:c389 Eacute;:c389 Ecaron;:c49a Ecirc:c38a Ecirc;:c38a Ecy;:d0ad Edot;:c496 Efr;:f09d9488 Egrave:c388 Egrave;:c388 Element;:e28888 Emacr;:c492 EmptySmallSquare;:e297bb EmptyVerySmallSquare;:e296ab Eogon;:c498 Eopf;:f09d94bc Epsilon;:ce95 Equal;:e2a9b5 EqualTilde;:e28982 Equilibrium;:e2878c Escr;:e284b0 Esim;:e2a9b3 Eta;:ce97 Euml:c38b Euml;:c38b Exists;:e28883 ExponentialE;:e28587 Fcy;:d0a4 Ffr;:f09d9489 FilledSmallSquare;:e297bc FilledVerySmallSquare;:e296aa Fopf;:f09d94bd ForAll;:e28880 Fouriertrf;:e284b1 Fscr;:e284b1 GJcy;:d083 GT:3e GT;:3e Gamma;:ce93 Gammad;:cf9c Gbreve;:c49e Gcedil;:c4a2 Gcirc;:c49c Gcy;:d093 Gdot;:c4a0 Gfr;:f09d948a Gg;:e28b99 Gopf;:f09d94be GreaterEqual;:e289a5 GreaterEqualLess;:e28b9b GreaterFullEqual;:e289a7 GreaterGreater;:e2aaa2 GreaterLess;:e289b7 GreaterSlantEqual;:e2a9be GreaterTilde;:e289b3 Gscr;:f09d92a2 Gt;:e289ab HARDcy;:d0aa Hacek;:cb87 Hat;:5e Hcirc;:c4a4 Hfr;:e2848c HilbertSpace;:e2848b Hopf;:e2848d HorizontalLine;:e29480 Hscr;:e2848b Hstrok;:c4a6 HumpDownHump;:e2898e HumpEqual;:e2898f IEcy;:d095 IJlig;:c4b2 IOcy;:d081 Iacute:c38d Iacute;:c38d Icirc:c38e Icirc;:c38e Icy;:d098 Idot;:c4b0 Ifr;:e28491 Igrave:c38c Igrave;:c38c Im;:e28491 Imacr;:c4aa ImaginaryI;:e28588 Implies;:e28792 Int;:e288ac Integral;:e288ab Intersection;:e28b82 InvisibleComma;:e281a3 InvisibleTimes;:e281a2 Iogon;:c4ae Iopf;:f09d9580 Iota;:ce99 Iscr;:e28490 Itilde;:c4a8 Iukcy;:d086 Iuml:c38f Iuml;:c38f Jcirc;:c4b4 Jcy;:d099 Jfr;:f09d948d Jopf;:f09d9581 Jscr;:f09d92a5 Jsercy;:d088 Jukcy;:d084 KHcy;:d0a5 KJcy;:d08c Kappa;:ce9a Kcedil;:c4b6 Kcy;:d09a Kfr;:f09d948e Kopf;:f09d9582 Kscr;:f09d92a6 LJcy;:d089 LT:3c LT;:3c Lacute;:c4b9 Lambda;:ce9b Lang;:e29faa Laplacetrf;:e28492 Larr;:e2869e Lcaron;:c4bd Lcedil;:c4bb Lcy;:d09b LeftAngleBracket;:e29fa8 LeftArrow;:e28690 LeftArrowBar;:e287a4 LeftArrowRightArrow;:e28786 LeftCeiling;:e28c88 LeftDoubleBracket;:e29fa6 LeftDownTeeVector;:e2a5a1 LeftDownVector;:e28783 LeftDownVectorBar;:e2a599 LeftFloor;:e28c8a LeftRightArrow;:e28694 LeftRightVector;:e2a58e LeftTee;:e28aa3 LeftTeeArrow;:e286a4 LeftTeeVector;:e2a59a LeftTriangle;:e28ab2 LeftTriangleBar;:e2a78f LeftTriangleEqual;:e28ab4 LeftUpDownVector;:e2a591 LeftUpTeeVector;:e2a5a0 LeftUpVector;:e286bf LeftUpVectorBar;:e2a598 LeftVector;:e286bc LeftVectorBar;:e2a592 Leftarrow;:e28790 Leftrightarrow;:e28794 LessEqualGreater;:e28b9a LessFullEqual;:e289a6 LessGreater;:e289b6 LessLess;:e2aaa1 LessSlantEqual;:e2a9bd LessTilde;:e289b2 Lfr;:f09d948f Ll;:e28b98 Lleftarrow;:e2879a Lmidot;:c4bf LongLeftArrow;:e29fb5 LongLeftRightArrow;:e29fb7 LongRightArrow;:e29fb6 Longleftarrow;:e29fb8 Longleftrightarrow;:e29fba Longrightarrow;:e29fb9 Lopf;:f09d9583 LowerLeftArrow;:e28699 LowerRightArrow;:e28698 Lscr;:e28492 Lsh;:e286b0 Lstrok;:c581 Lt;:e289aa Map;:e2a485 Mcy;:d09c MediumSpace;:e2819f Mellintrf;:e284b3 Mfr;:f09d9490 MinusPlus;:e28893 Mopf;:f09d9584 Mscr;:e284b3 Mu;:ce9c NJcy;:d08a Nacute;:c583 Ncaron;:c587 Ncedil;:c585 Ncy;:d09d NegativeMediumSpace;:e2808b NegativeThickSpace;:e2808b NegativeThinSpace;:e2808b NegativeVeryThinSpace;:e2808b NestedGreaterGreater;:e289ab NestedLessLess;:e289aa NewLine;:0a Nfr;:f09d9491 NoBreak;:e281a0 NonBreakingSpace;:c2a0 Nopf;:e28495 Not;:e2abac NotCongruent;:e289a2 NotCupCap;:e289ad NotDoubleVerticalBar;:e288a6 NotElement;:e28889 NotEqual;:e289a0 NotEqualTilde;:e28982ccb8 NotExists;:e28884 NotGreater;:e289af NotGreaterEqual;:e289b1 NotGreaterFullEqual;:e289a7ccb8 NotGreaterGreater;:e289abccb8 NotGreaterLess;:e289b9 NotGreaterSlantEqual;:e2a9beccb8 NotGreaterTilde;:e289b5 NotHumpDownHump;:e2898eccb8 NotHumpEqual;:e2898fccb8 NotLeftTriangle;:e28baa NotLeftTriangleBar;:e2a78fccb8 NotLeftTriangleEqual;:e28bac NotLess;:e289ae NotLessEqual;:e289b0 NotLessGreater;:e289b8 NotLessLess;:e289aaccb8 NotLessSlantEqual;:e2a9bdccb8 NotLessTilde;:e289b4 NotNestedGreaterGreater;:e2aaa2ccb8 NotNestedLessLess;:e2aaa1ccb8 NotPrecedes;:e28a80 NotPrecedesEqual;:e2aaafccb8 NotPrecedesSlantEqual;:e28ba0 NotReverseElement;:e2888c NotRightTriangle;:e28bab NotRightTriangleBar;:e2a790ccb8 NotRightTriangleEqual;:e28bad NotSquareSubset;:e28a8fccb8 NotSquareSubsetEqual;:e28ba2 NotSquareSuperset;:e28a90ccb8 NotSquareSupersetEqual;:e28ba3 NotSubset;:e28a82e28392 NotSubsetEqual;:e28a88 NotSucceeds;:e28a81 NotSucceedsEqual;:e2aab0ccb8 NotSucceedsSlantEqual;:e28ba1 NotSucceedsTilde;:e289bfccb8 NotSuperset;:e28a83e28392 NotSupersetEqual;:e28a89 NotTilde;:e28981 NotTildeEqual;:e28984 NotTildeFullEqual;:e28987 NotTildeTilde;:e28989 NotVerticalBar;:e288a4 Nscr;:f09d92a9 Ntilde:c391 Ntilde;:c391 Nu;:ce9d OElig;:c592 Oacute:c393 Oacute;:c393 Ocirc:c394 Ocirc;:c394 Ocy;:d09e Odblac;:c590 Ofr;:f09d9492 Ograve:c392 Ograve;:c392 Omacr;:c58c Omega;:cea9 Omicron;:ce9f Oopf;:f09d9586 OpenCurlyDoubleQuote;:e2809c OpenCurlyQuote;:e28098 Or;:e2a994 Oscr;:f09d92aa Oslash:c398 Oslash;:c398 Otilde:c395 Otilde;:c395 Otimes;:e2a8b7 Ouml:c396 Ouml;:c396 OverBar;:e280be OverBrace;:e28f9e OverBracket;:e28eb4 OverParenthesis;:e28f9c PartialD;:e28882 Pcy;:d09f Pfr;:f09d9493 Phi;:cea6 Pi;:cea0 PlusMinus;:c2b1 Poincareplane;:e2848c Popf;:e28499 Pr;:e2aabb Precedes;:e289ba PrecedesEqual;:e2aaaf PrecedesSlantEqual;:e289bc PrecedesTilde;:e289be Prime;:e280b3 Product;:e2888f Proportion;:e288b7 Proportional;:e2889d Pscr;:f09d92ab Psi;:cea8 QUOT:22 QUOT;:22 Qfr;:f09d9494 Qopf;:e2849a Qscr;:f09d92ac RBarr;:e2a490 REG:c2ae REG;:c2ae Racute;:c594 Rang;:e29fab Rarr;:e286a0 Rarrtl;:e2a496 Rcaron;:c598 Rcedil;:c596 Rcy;:d0a0 Re;:e2849c ReverseElement;:e2888b ReverseEquilibrium;:e2878b ReverseUpEquilibrium;:e2a5af Rfr;:e2849c Rho;:cea1 RightAngleBracket;:e29fa9 RightArrow;:e28692 RightArrowBar;:e287a5 RightArrowLeftArrow;:e28784 RightCeiling;:e28c89 RightDoubleBracket;:e29fa7 RightDownTeeVector;:e2a59d RightDownVector;:e28782 RightDownVectorBar;:e2a595 RightFloor;:e28c8b RightTee;:e28aa2 RightTeeArrow;:e286a6 RightTeeVector;:e2a59b RightTriangle;:e28ab3 RightTriangleBar;:e2a790 RightTriangleEqual;:e28ab5 RightUpDownVector;:e2a58f RightUpTeeVector;:e2a59c RightUpVector;:e286be RightUpVectorBar;:e2a594 RightVector;:e28780 RightVectorBar;:e2a593 Rightarrow;:e28792 Ropf;:e2849d RoundImplies;:e2a5b0 Rrightarrow;:e2879b Rscr;:e2849b Rsh;:e286b1 RuleDelayed;:e2a7b4 SHCHcy;:d0a9 SHcy;:d0a8 SOFTcy;:d0ac Sacute;:c59a Sc;:e2aabc Scaron;:c5a0 Scedil;:c59e Scirc;:c59c Scy;:d0a1 Sfr;:f09d9496 ShortDownArrow;:e28693 ShortLeftArrow;:e28690 ShortRightArrow;:e28692 ShortUpArrow;:e28691 Sigma;:cea3 SmallCircle;:e28898 Sopf;:f09d958a Sqrt;:e2889a Square;:e296a1 SquareIntersection;:e28a93 SquareSubset;:e28a8f SquareSubsetEqual;:e28a91 SquareSuperset;:e28a90 SquareSupersetEqual;:e28a92 SquareUnion;:e28a94 Sscr;:f09d92ae Star;:e28b86 Sub;:e28b90 Subset;:e28b90 SubsetEqual;:e28a86 Succeeds;:e289bb SucceedsEqual;:e2aab0 SucceedsSlantEqual;:e289bd SucceedsTilde;:e289bf SuchThat;:e2888b Sum;:e28891 Sup;:e28b91 Superset;:e28a83 SupersetEqual;:e28a87 Supset;:e28b91 THORN:c39e THORN;:c39e TRADE;:e284a2 TSHcy;:d08b TScy;:d0a6 Tab;:09 Tau;:cea4 Tcaron;:c5a4 Tcedil;:c5a2 Tcy;:d0a2 Tfr;:f09d9497 Therefore;:e288b4 Theta;:ce98 ThickSpace;:e2819fe2808a ThinSpace;:e28089 Tilde;:e288bc TildeEqual;:e28983 TildeFullEqual;:e28985 TildeTilde;:e28988 Topf;:f09d958b TripleDot;:e2839b Tscr;:f09d92af Tstrok;:c5a6 Uacute:c39a Uacute;:c39a Uarr;:e2869f Uarrocir;:e2a589 Ubrcy;:d08e Ubreve;:c5ac Ucirc:c39b Ucirc;:c39b Ucy;:d0a3 Udblac;:c5b0 Ufr;:f09d9498 Ugrave:c399 Ugrave;:c399 Umacr;:c5aa UnderBar;:5f UnderBrace;:e28f9f UnderBracket;:e28eb5 UnderParenthesis;:e28f9d Union;:e28b83 UnionPlus;:e28a8e Uogon;:c5b2 Uopf;:f09d958c UpArrow;:e28691 UpArrowBar;:e2a492 UpArrowDownArrow;:e28785 UpDownArrow;:e28695 UpEquilibrium;:e2a5ae UpTee;:e28aa5 UpTeeArrow;:e286a5 Uparrow;:e28791 Updownarrow;:e28795 UpperLeftArrow;:e28696 UpperRightArrow;:e28697 Upsi;:cf92 Upsilon;:cea5 Uring;:c5ae Uscr;:f09d92b0 Utilde;:c5a8 Uuml:c39c Uuml;:c39c VDash;:e28aab Vbar;:e2abab Vcy;:d092 Vdash;:e28aa9 Vdashl;:e2aba6 Vee;:e28b81 Verbar;:e28096 Vert;:e28096 VerticalBar;:e288a3 VerticalLine;:7c VerticalSeparator;:e29d98 VerticalTilde;:e28980 VeryThinSpace;:e2808a Vfr;:f09d9499 Vopf;:f09d958d Vscr;:f09d92b1 Vvdash;:e28aaa Wcirc;:c5b4 Wedge;:e28b80 Wfr;:f09d949a Wopf;:f09d958e Wscr;:f09d92b2 Xfr;:f09d949b Xi;:ce9e Xopf;:f09d958f Xscr;:f09d92b3 YAcy;:d0af YIcy;:d087 YUcy;:d0ae Yacute:c39d Yacute;:c39d Ycirc;:c5b6 Ycy;:d0ab Yfr;:f09d949c Yopf;:f09d9590 Yscr;:f09d92b4 Yuml;:c5b8 ZHcy;:d096 Zacute;:c5b9 Zcaron;:c5bd Zcy;:d097 Zdot;:c5bb ZeroWidthSpace;:e2808b Zeta;:ce96 Zfr;:e284a8 Zopf;:e284a4 Zscr;:f09d92b5 aacute:c3a1 aacute;:c3a1 abreve;:c483 ac;:e288be acE;:e288beccb3 acd;:e288bf acirc:c3a2 acirc;:c3a2 acute:c2b4 acute;:c2b4 acy;:d0b0 aelig:c3a6 aelig;:c3a6 af;:e281a1 afr;:f09d949e agrave:c3a0 agrave;:c3a0 alefsym;:e284b5 aleph;:e284b5 alpha;:ceb1 amacr;:c481 amalg;:e2a8bf amp:26 amp;:26 and;:e288a7 andand;:e2a995 andd;:e2a99c andslope;:e2a998 andv;:e2a99a ang;:e288a0 ange;:e2a6a4 angle;:e288a0 angmsd;:e288a1 angmsdaa;:e2a6a8 angmsdab;:e2a6a9 angmsdac;:e2a6aa angmsdad;:e2a6ab angmsdae;:e2a6ac angmsdaf;:e2a6ad angmsdag;:e2a6ae angmsdah;:e2a6af angrt;:e2889f angrtvb;:e28abe angrtvbd;:e2a69d angsph;:e288a2 angst;:c385 angzarr;:e28dbc aogon;:c485 aopf;:f09d9592 ap;:e28988 apE;:e2a9b0 apacir;:e2a9af ape;:e2898a apid;:e2898b apos;:27 approx;:e28988 approxeq;:e2898a aring:c3a5 aring;:c3a5 ascr;:f09d92b6 ast;:2a asymp;:e28988 asympeq;:e2898d atilde:c3a3 atilde;:c3a3 auml:c3a4 auml;:c3a4 awconint;:e288b3 awint;:e2a891 bNot;:e2abad backcong;:e2898c backepsilon;:cfb6 backprime;:e280b5 backsim;:e288bd backsimeq;:e28b8d barvee;:e28abd barwed;:e28c85 barwedge;:e28c85 bbrk;:e28eb5 bbrktbrk;:e28eb6 bcong;:e2898c bcy;:d0b1 bdquo;:e2809e becaus;:e288b5 because;:e288b5 bemptyv;:e2a6b0 bepsi;:cfb6 bernou;:e284ac beta;:ceb2 beth;:e284b6 between;:e289ac bfr;:f09d949f bigcap;:e28b82 bigcirc;:e297af bigcup;:e28b83 bigodot;:e2a880 bigoplus;:e2a881 bigotimes;:e2a882 bigsqcup;:e2a886 bigstar;:e29885 bigtriangledown;:e296bd bigtriangleup;:e296b3 biguplus;:e2a884 bigvee;:e28b81 bigwedge;:e28b80 bkarow;:e2a48d blacklozenge;:e2a7ab blacksquare;:e296aa blacktriangle;:e296b4 blacktriangledown;:e296be blacktriangleleft;:e29782 blacktriangleright;:e296b8 blank;:e290a3 blk12;:e29692 blk14;:e29691 blk34;:e29693 block;:e29688 bne;:3de283a5 bnequiv;:e289a1e283a5 bnot;:e28c90 bopf;:f09d9593 bot;:e28aa5 bottom;:e28aa5 bowtie;:e28b88 boxDL;:e29597 boxDR;:e29594 boxDl;:e29596 boxDr;:e29593 boxH;:e29590 boxHD;:e295a6 boxHU;:e295a9 boxHd;:e295a4 boxHu;:e295a7 boxUL;:e2959d boxUR;:e2959a boxUl;:e2959c boxUr;:e29599 boxV;:e29591 boxVH;:e295ac boxVL;:e295a3 boxVR;:e295a0 boxVh;:e295ab boxVl;:e295a2 boxVr;:e2959f boxbox;:e2a789 boxdL;:e29595 boxdR;:e29592 boxdl;:e29490 boxdr;:e2948c boxh;:e29480 boxhD;:e295a5 boxhU;:e295a8 boxhd;:e294ac boxhu;:e294b4 boxminus;:e28a9f boxplus;:e28a9e boxtimes;:e28aa0 boxuL;:e2959b boxuR;:e29598 boxul;:e29498 boxur;:e29494 boxv;:e29482 boxvH;:e295aa boxvL;:e295a1 boxvR;:e2959e boxvh;:e294bc boxvl;:e294a4 boxvr;:e2949c bprime;:e280b5 breve;:cb98 brvbar:c2a6 brvbar;:c2a6 bscr;:f09d92b7 bsemi;:e2818f bsim;:e288bd bsime;:e28b8d bsol;:5c bsolb;:e2a785 bsolhsub;:e29f88 bull;:e280a2 bullet;:e280a2 bump;:e2898e bumpE;:e2aaae bumpe;:e2898f bumpeq;:e2898f cacute;:c487 cap;:e288a9 capand;:e2a984 capbrcup;:e2a989 capcap;:e2a98b capcup;:e2a987 capdot;:e2a980 caps;:e288a9efb880 caret;:e28181 caron;:cb87 ccaps;:e2a98d ccaron;:c48d ccedil:c3a7 ccedil;:c3a7 ccirc;:c489 ccups;:e2a98c ccupssm;:e2a990 cdot;:c48b cedil:c2b8 cedil;:c2b8 cemptyv;:e2a6b2 cent:c2a2 cent;:c2a2 centerdot;:c2b7 cfr;:f09d94a0 chcy;:d187 check;:e29c93 checkmark;:e29c93 chi;:cf87 cir;:e2978b cirE;:e2a783 circ;:cb86 circeq;:e28997 circlearrowleft;:e286ba circlearrowright;:e286bb circledR;:c2ae circledS;:e29388 circledast;:e28a9b circledcirc;:e28a9a circleddash;:e28a9d cire;:e28997 cirfnint;:e2a890 cirmid;:e2abaf cirscir;:e2a782 clubs;:e299a3 clubsuit;:e299a3 colon;:3a colone;:e28994 coloneq;:e28994 comma;:2c commat;:40 comp;:e28881 compfn;:e28898 complement;:e28881 complexes;:e28482 cong;:e28985 congdot;:e2a9ad conint;:e288ae copf;:f09d9594 coprod;:e28890 copy:c2a9 copy;:c2a9 copysr;:e28497 crarr;:e286b5 cross;:e29c97 cscr;:f09d92b8 csub;:e2ab8f csube;:e2ab91 csup;:e2ab90 csupe;:e2ab92 ctdot;:e28baf cudarrl;:e2a4b8 cudarrr;:e2a4b5 cuepr;:e28b9e cuesc;:e28b9f cularr;:e286b6 cularrp;:e2a4bd cup;:e288aa cupbrcap;:e2a988 cupcap;:e2a986 cupcup;:e2a98a cupdot;:e28a8d cupor;:e2a985 cups;:e288aaefb880 curarr;:e286b7 curarrm;:e2a4bc curlyeqprec;:e28b9e curlyeqsucc;:e28b9f curlyvee;:e28b8e curlywedge;:e28b8f curren:c2a4 curren;:c2a4 curvearrowleft;:e286b6 curvearrowright;:e286b7 cuvee;:e28b8e cuwed;:e28b8f cwconint;:e288b2 cwint;:e288b1 cylcty;:e28cad dArr;:e28793 dHar;:e2a5a5 dagger;:e280a0 daleth;:e284b8 darr;:e28693 dash;:e28090 dashv;:e28aa3 dbkarow;:e2a48f dblac;:cb9d dcaron;:c48f dcy;:d0b4 dd;:e28586 ddagger;:e280a1 ddarr;:e2878a ddotseq;:e2a9b7 deg:c2b0 deg;:c2b0 delta;:ceb4 demptyv;:e2a6b1 dfisht;:e2a5bf dfr;:f09d94a1 dharl;:e28783 dharr;:e28782 diam;:e28b84 diamond;:e28b84 diamondsuit;:e299a6 diams;:e299a6 die;:c2a8 digamma;:cf9d disin;:e28bb2 div;:c3b7 divide:c3b7 divide;:c3b7 divideontimes;:e28b87 divonx;:e28b87 djcy;:d192 dlcorn;:e28c9e dlcrop;:e28c8d dollar;:24 dopf;:f09d9595 dot;:cb99 doteq;:e28990 doteqdot;:e28991 dotminus;:e288b8 dotplus;:e28894 dotsquare;:e28aa1 doublebarwedge;:e28c86 downarrow;:e28693 downdownarrows;:e2878a downharpoonleft;:e28783 downharpoonright;:e28782 drbkarow;:e2a490 drcorn;:e28c9f drcrop;:e28c8c dscr;:f09d92b9 dscy;:d195 dsol;:e2a7b6 dstrok;:c491 dtdot;:e28bb1 dtri;:e296bf dtrif;:e296be duarr;:e287b5 duhar;:e2a5af dwangle;:e2a6a6 dzcy;:d19f dzigrarr;:e29fbf eDDot;:e2a9b7 eDot;:e28991 eacute:c3a9 eacute;:c3a9 easter;:e2a9ae ecaron;:c49b ecir;:e28996 ecirc:c3aa ecirc;:c3aa ecolon;:e28995 ecy;:d18d edot;:c497 ee;:e28587 efDot;:e28992 efr;:f09d94a2 eg;:e2aa9a egrave:c3a8 egrave;:c3a8 egs;:e2aa96 egsdot;:e2aa98 el;:e2aa99 elinters;:e28fa7 ell;:e28493 els;:e2aa95 elsdot;:e2aa97 emacr;:c493 empty;:e28885 emptyset;:e28885 emptyv;:e28885 emsp13;:e28084 emsp14;:e28085 emsp;:e28083 eng;:c58b ensp;:e28082 eogon;:c499 eopf;:f09d9596 epar;:e28b95 eparsl;:e2a7a3 eplus;:e2a9b1 epsi;:ceb5 epsilon;:ceb5 epsiv;:cfb5 eqcirc;:e28996 eqcolon;:e28995 eqsim;:e28982 eqslantgtr;:e2aa96 eqslantless;:e2aa95 equals;:3d equest;:e2899f equiv;:e289a1 equivDD;:e2a9b8 eqvparsl;:e2a7a5 erDot;:e28993 erarr;:e2a5b1 escr;:e284af esdot;:e28990 esim;:e28982 eta;:ceb7 eth:c3b0 eth;:c3b0 euml:c3ab euml;:c3ab euro;:e282ac excl;:21 exist;:e28883 expectation;:e284b0 exponentiale;:e28587 fallingdotseq;:e28992 fcy;:d184 female;:e29980 ffilig;:efac83 fflig;:efac80 ffllig;:efac84 ffr;:f09d94a3 filig;:efac81 fjlig;:666a flat;:e299ad fllig;:efac82 fltns;:e296b1 fnof;:c692 fopf;:f09d9597 forall;:e28880 fork;:e28b94 forkv;:e2ab99 fpartint;:e2a88d frac12:c2bd frac12;:c2bd frac13;:e28593 frac14:c2bc frac14;:c2bc frac15;:e28595 frac16;:e28599 frac18;:e2859b frac23;:e28594 frac25;:e28596 frac34:c2be frac34;:c2be frac35;:e28597 frac38;:e2859c frac45;:e28598 frac56;:e2859a frac58;:e2859d frac78;:e2859e frasl;:e28184 frown;:e28ca2 fscr;:f09d92bb gE;:e289a7 gEl;:e2aa8c gacute;:c7b5 gamma;:ceb3 gammad;:cf9d gap;:e2aa86 gbreve;:c49f gcirc;:c49d gcy;:d0b3 gdot;:c4a1 ge;:e289a5 gel;:e28b9b geq;:e289a5 geqq;:e289a7 geqslant;:e2a9be ges;:e2a9be gescc;:e2aaa9 gesdot;:e2aa80 gesdoto;:e2aa82 gesdotol;:e2aa84 gesl;:e28b9befb880 gesles;:e2aa94 gfr;:f09d94a4 gg;:e289ab ggg;:e28b99 gimel;:e284b7 gjcy;:d193 gl;:e289b7 glE;:e2aa92 gla;:e2aaa5 glj;:e2aaa4 gnE;:e289a9 gnap;:e2aa8a gnapprox;:e2aa8a gne;:e2aa88 gneq;:e2aa88 gneqq;:e289a9 gnsim;:e28ba7 gopf;:f09d9598 grave;:60 gscr;:e2848a gsim;:e289b3 gsime;:e2aa8e gsiml;:e2aa90 gt:3e gt;:3e gtcc;:e2aaa7 gtcir;:e2a9ba gtdot;:e28b97 gtlPar;:e2a695 gtquest;:e2a9bc gtrapprox;:e2aa86 gtrarr;:e2a5b8 gtrdot;:e28b97 gtreqless;:e28b9b gtreqqless;:e2aa8c gtrless;:e289b7 gtrsim;:e289b3 gvertneqq;:e289a9efb880 gvnE;:e289a9efb880 hArr;:e28794 hairsp;:e2808a half;:c2bd hamilt;:e2848b hardcy;:d18a harr;:e28694 harrcir;:e2a588 harrw;:e286ad hbar;:e2848f hcirc;:c4a5 hearts;:e299a5 heartsuit;:e299a5 hellip;:e280a6 hercon;:e28ab9 hfr;:f09d94a5 hksearow;:e2a4a5 hkswarow;:e2a4a6 hoarr;:e287bf homtht;:e288bb hookleftarrow;:e286a9 hookrightarrow;:e286aa hopf;:f09d9599 horbar;:e28095 hscr;:f09d92bd hslash;:e2848f hstrok;:c4a7 hybull;:e28183 hyphen;:e28090 iacute:c3ad iacute;:c3ad ic;:e281a3 icirc:c3ae icirc;:c3ae icy;:d0b8 iecy;:d0b5 iexcl:c2a1 iexcl;:c2a1 iff;:e28794 ifr;:f09d94a6 igrave:c3ac igrave;:c3ac ii;:e28588 iiiint;:e2a88c iiint;:e288ad iinfin;:e2a79c iiota;:e284a9 ijlig;:c4b3 imacr;:c4ab image;:e28491 imagline;:e28490 imagpart;:e28491 imath;:c4b1 imof;:e28ab7 imped;:c6b5 in;:e28888 incare;:e28485 infin;:e2889e infintie;:e2a79d inodot;:c4b1 int;:e288ab intcal;:e28aba integers;:e284a4 intercal;:e28aba intlarhk;:e2a897 intprod;:e2a8bc iocy;:d191 iogon;:c4af iopf;:f09d959a iota;:ceb9 iprod;:e2a8bc iquest:c2bf iquest;:c2bf iscr;:f09d92be isin;:e28888 isinE;:e28bb9 isindot;:e28bb5 isins;:e28bb4 isinsv;:e28bb3 isinv;:e28888 it;:e281a2 itilde;:c4a9 iukcy;:d196 iuml:c3af iuml;:c3af jcirc;:c4b5 jcy;:d0b9 jfr;:f09d94a7 jmath;:c8b7 jopf;:f09d959b jscr;:f09d92bf jsercy;:d198 jukcy;:d194 kappa;:ceba kappav;:cfb0 kcedil;:c4b7 kcy;:d0ba kfr;:f09d94a8 kgreen;:c4b8 khcy;:d185 kjcy;:d19c kopf;:f09d959c kscr;:f09d9380 lAarr;:e2879a lArr;:e28790 lAtail;:e2a49b lBarr;:e2a48e lE;:e289a6 lEg;:e2aa8b lHar;:e2a5a2 lacute;:c4ba laemptyv;:e2a6b4 lagran;:e28492 lambda;:cebb lang;:e29fa8 langd;:e2a691 langle;:e29fa8 lap;:e2aa85 laquo:c2ab laquo;:c2ab larr;:e28690 larrb;:e287a4 larrbfs;:e2a49f larrfs;:e2a49d larrhk;:e286a9 larrlp;:e286ab larrpl;:e2a4b9 larrsim;:e2a5b3 larrtl;:e286a2 lat;:e2aaab latail;:e2a499 late;:e2aaad lates;:e2aaadefb880 lbarr;:e2a48c lbbrk;:e29db2 lbrace;:7b lbrack;:5b lbrke;:e2a68b lbrksld;:e2a68f lbrkslu;:e2a68d lcaron;:c4be lcedil;:c4bc lceil;:e28c88 lcub;:7b lcy;:d0bb ldca;:e2a4b6 ldquo;:e2809c ldquor;:e2809e ldrdhar;:e2a5a7 ldrushar;:e2a58b ldsh;:e286b2 le;:e289a4 leftarrow;:e28690 leftarrowtail;:e286a2 leftharpoondown;:e286bd leftharpoonup;:e286bc leftleftarrows;:e28787 leftrightarrow;:e28694 leftrightarrows;:e28786 leftrightharpoons;:e2878b leftrightsquigarrow;:e286ad leftthreetimes;:e28b8b leg;:e28b9a leq;:e289a4 leqq;:e289a6 leqslant;:e2a9bd les;:e2a9bd lescc;:e2aaa8 lesdot;:e2a9bf lesdoto;:e2aa81 lesdotor;:e2aa83 lesg;:e28b9aefb880 lesges;:e2aa93 lessapprox;:e2aa85 lessdot;:e28b96 lesseqgtr;:e28b9a lesseqqgtr;:e2aa8b lessgtr;:e289b6 lesssim;:e289b2 lfisht;:e2a5bc lfloor;:e28c8a lfr;:f09d94a9 lg;:e289b6 lgE;:e2aa91 lhard;:e286bd lharu;:e286bc lharul;:e2a5aa lhblk;:e29684 ljcy;:d199 ll;:e289aa llarr;:e28787 llcorner;:e28c9e llhard;:e2a5ab lltri;:e297ba lmidot;:c580 lmoust;:e28eb0 lmoustache;:e28eb0 lnE;:e289a8 lnap;:e2aa89 lnapprox;:e2aa89 lne;:e2aa87 lneq;:e2aa87 lneqq;:e289a8 lnsim;:e28ba6 loang;:e29fac loarr;:e287bd lobrk;:e29fa6 longleftarrow;:e29fb5 longleftrightarrow;:e29fb7 longmapsto;:e29fbc longrightarrow;:e29fb6 looparrowleft;:e286ab looparrowright;:e286ac lopar;:e2a685 lopf;:f09d959d loplus;:e2a8ad lotimes;:e2a8b4 lowast;:e28897 lowbar;:5f loz;:e2978a lozenge;:e2978a lozf;:e2a7ab lpar;:28 lparlt;:e2a693 lrarr;:e28786 lrcorner;:e28c9f lrhar;:e2878b lrhard;:e2a5ad lrm;:e2808e lrtri;:e28abf lsaquo;:e280b9 lscr;:f09d9381 lsh;:e286b0 lsim;:e289b2 lsime;:e2aa8d lsimg;:e2aa8f lsqb;:5b lsquo;:e28098 lsquor;:e2809a lstrok;:c582 lt:3c lt;:3c ltcc;:e2aaa6 ltcir;:e2a9b9 ltdot;:e28b96 lthree;:e28b8b ltimes;:e28b89 ltlarr;:e2a5b6 ltquest;:e2a9bb ltrPar;:e2a696 ltri;:e29783 ltrie;:e28ab4 ltrif;:e29782 lurdshar;:e2a58a luruhar;:e2a5a6 lvertneqq;:e289a8efb880 lvnE;:e289a8efb880 mDDot;:e288ba macr:c2af macr;:c2af male;:e29982 malt;:e29ca0 maltese;:e29ca0 map;:e286a6 mapsto;:e286a6 mapstodown;:e286a7 mapstoleft;:e286a4 mapstoup;:e286a5 marker;:e296ae mcomma;:e2a8a9 mcy;:d0bc mdash;:e28094 measuredangle;:e288a1 mfr;:f09d94aa mho;:e284a7 micro:c2b5 micro;:c2b5 mid;:e288a3 midast;:2a midcir;:e2abb0 middot:c2b7 middot;:c2b7 minus;:e28892 minusb;:e28a9f minusd;:e288b8 minusdu;:e2a8aa mlcp;:e2ab9b mldr;:e280a6 mnplus;:e28893 models;:e28aa7 mopf;:f09d959e mp;:e28893 mscr;:f09d9382 mstpos;:e288be mu;:cebc multimap;:e28ab8 mumap;:e28ab8 nGg;:e28b99ccb8 nGt;:e289abe28392 nGtv;:e289abccb8 nLeftarrow;:e2878d nLeftrightarrow;:e2878e nLl;:e28b98ccb8 nLt;:e289aae28392 nLtv;:e289aaccb8 nRightarrow;:e2878f nVDash;:e28aaf nVdash;:e28aae nabla;:e28887 nacute;:c584 nang;:e288a0e28392 nap;:e28989 napE;:e2a9b0ccb8 napid;:e2898bccb8 napos;:c589 napprox;:e28989 natur;:e299ae natural;:e299ae naturals;:e28495 nbsp:c2a0 nbsp;:c2a0 nbump;:e2898eccb8 nbumpe;:e2898fccb8 ncap;:e2a983 ncaron;:c588 ncedil;:c586 ncong;:e28987 ncongdot;:e2a9adccb8 ncup;:e2a982 ncy;:d0bd ndash;:e28093 ne;:e289a0 neArr;:e28797 nearhk;:e2a4a4 nearr;:e28697 nearrow;:e28697 nedot;:e28990ccb8 nequiv;:e289a2 nesear;:e2a4a8 nesim;:e28982ccb8 nexist;:e28884 nexists;:e28884 nfr;:f09d94ab ngE;:e289a7ccb8 nge;:e289b1 ngeq;:e289b1 ngeqq;:e289a7ccb8 ngeqslant;:e2a9beccb8 nges;:e2a9beccb8 ngsim;:e289b5 ngt;:e289af ngtr;:e289af nhArr;:e2878e nharr;:e286ae nhpar;:e2abb2 ni;:e2888b nis;:e28bbc nisd;:e28bba niv;:e2888b njcy;:d19a nlArr;:e2878d nlE;:e289a6ccb8 nlarr;:e2869a nldr;:e280a5 nle;:e289b0 nleftarrow;:e2869a nleftrightarrow;:e286ae nleq;:e289b0 nleqq;:e289a6ccb8 nleqslant;:e2a9bdccb8 nles;:e2a9bdccb8 nless;:e289ae nlsim;:e289b4 nlt;:e289ae nltri;:e28baa nltrie;:e28bac nmid;:e288a4 nopf;:f09d959f not:c2ac not;:c2ac notin;:e28889 notinE;:e28bb9ccb8 notindot;:e28bb5ccb8 notinva;:e28889 notinvb;:e28bb7 notinvc;:e28bb6 notni;:e2888c notniva;:e2888c notnivb;:e28bbe notnivc;:e28bbd npar;:e288a6 nparallel;:e288a6 nparsl;:e2abbde283a5 npart;:e28882ccb8 npolint;:e2a894 npr;:e28a80 nprcue;:e28ba0 npre;:e2aaafccb8 nprec;:e28a80 npreceq;:e2aaafccb8 nrArr;:e2878f nrarr;:e2869b nrarrc;:e2a4b3ccb8 nrarrw;:e2869dccb8 nrightarrow;:e2869b nrtri;:e28bab nrtrie;:e28bad nsc;:e28a81 nsccue;:e28ba1 nsce;:e2aab0ccb8 nscr;:f09d9383 nshortmid;:e288a4 nshortparallel;:e288a6 nsim;:e28981 nsime;:e28984 nsimeq;:e28984 nsmid;:e288a4 nspar;:e288a6 nsqsube;:e28ba2 nsqsupe;:e28ba3 nsub;:e28a84 nsubE;:e2ab85ccb8 nsube;:e28a88 nsubset;:e28a82e28392 nsubseteq;:e28a88 nsubseteqq;:e2ab85ccb8 nsucc;:e28a81 nsucceq;:e2aab0ccb8 nsup;:e28a85 nsupE;:e2ab86ccb8 nsupe;:e28a89 nsupset;:e28a83e28392 nsupseteq;:e28a89 nsupseteqq;:e2ab86ccb8 ntgl;:e289b9 ntilde:c3b1 ntilde;:c3b1 ntlg;:e289b8 ntriangleleft;:e28baa ntrianglelefteq;:e28bac ntriangleright;:e28bab ntrianglerighteq;:e28bad nu;:cebd num;:23 numero;:e28496 numsp;:e28087 nvDash;:e28aad nvHarr;:e2a484 nvap;:e2898de28392 nvdash;:e28aac nvge;:e289a5e28392 nvgt;:3ee28392 nvinfin;:e2a79e nvlArr;:e2a482 nvle;:e289a4e28392 nvlt;:3ce28392 nvltrie;:e28ab4e28392 nvrArr;:e2a483 nvrtrie;:e28ab5e28392 nvsim;:e288bce28392 nwArr;:e28796 nwarhk;:e2a4a3 nwarr;:e28696 nwarrow;:e28696 nwnear;:e2a4a7 oS;:e29388 oacute:c3b3 oacute;:c3b3 oast;:e28a9b ocir;:e28a9a ocirc:c3b4 ocirc;:c3b4 ocy;:d0be odash;:e28a9d odblac;:c591 odiv;:e2a8b8 odot;:e28a99 odsold;:e2a6bc oelig;:c593 ofcir;:e2a6bf ofr;:f09d94ac ogon;:cb9b ograve:c3b2 ograve;:c3b2 ogt;:e2a781 ohbar;:e2a6b5 ohm;:cea9 oint;:e288ae olarr;:e286ba olcir;:e2a6be olcross;:e2a6bb oline;:e280be olt;:e2a780 omacr;:c58d omega;:cf89 omicron;:cebf omid;:e2a6b6 ominus;:e28a96 oopf;:f09d95a0 opar;:e2a6b7 operp;:e2a6b9 oplus;:e28a95 or;:e288a8 orarr;:e286bb ord;:e2a99d order;:e284b4 orderof;:e284b4 ordf:c2aa ordf;:c2aa ordm:c2ba ordm;:c2ba origof;:e28ab6 oror;:e2a996 orslope;:e2a997 orv;:e2a99b oscr;:e284b4 oslash:c3b8 oslash;:c3b8 osol;:e28a98 otilde:c3b5 otilde;:c3b5 otimes;:e28a97 otimesas;:e2a8b6 ouml:c3b6 ouml;:c3b6 ovbar;:e28cbd par;:e288a5 para:c2b6 para;:c2b6 parallel;:e288a5 parsim;:e2abb3 parsl;:e2abbd part;:e28882 pcy;:d0bf percnt;:25 period;:2e permil;:e280b0 perp;:e28aa5 pertenk;:e280b1 pfr;:f09d94ad phi;:cf86 phiv;:cf95 phmmat;:e284b3 phone;:e2988e pi;:cf80 pitchfork;:e28b94 piv;:cf96 planck;:e2848f planckh;:e2848e plankv;:e2848f plus;:2b plusacir;:e2a8a3 plusb;:e28a9e pluscir;:e2a8a2 plusdo;:e28894 plusdu;:e2a8a5 pluse;:e2a9b2 plusmn:c2b1 plusmn;:c2b1 plussim;:e2a8a6 plustwo;:e2a8a7 pm;:c2b1 pointint;:e2a895 popf;:f09d95a1 pound:c2a3 pound;:c2a3 pr;:e289ba prE;:e2aab3 prap;:e2aab7 prcue;:e289bc pre;:e2aaaf prec;:e289ba precapprox;:e2aab7 preccurlyeq;:e289bc preceq;:e2aaaf precnapprox;:e2aab9 precneqq;:e2aab5 precnsim;:e28ba8 precsim;:e289be prime;:e280b2 primes;:e28499 prnE;:e2aab5 prnap;:e2aab9 prnsim;:e28ba8 prod;:e2888f profalar;:e28cae profline;:e28c92 profsurf;:e28c93 prop;:e2889d propto;:e2889d prsim;:e289be prurel;:e28ab0 pscr;:f09d9385 psi;:cf88 puncsp;:e28088 qfr;:f09d94ae qint;:e2a88c qopf;:f09d95a2 qprime;:e28197 qscr;:f09d9386 quaternions;:e2848d quatint;:e2a896 quest;:3f questeq;:e2899f quot:22 quot;:22 rAarr;:e2879b rArr;:e28792 rAtail;:e2a49c rBarr;:e2a48f rHar;:e2a5a4 race;:e288bdccb1 racute;:c595 radic;:e2889a raemptyv;:e2a6b3 rang;:e29fa9 rangd;:e2a692 range;:e2a6a5 rangle;:e29fa9 raquo:c2bb raquo;:c2bb rarr;:e28692 rarrap;:e2a5b5 rarrb;:e287a5 rarrbfs;:e2a4a0 rarrc;:e2a4b3 rarrfs;:e2a49e rarrhk;:e286aa rarrlp;:e286ac rarrpl;:e2a585 rarrsim;:e2a5b4 rarrtl;:e286a3 rarrw;:e2869d ratail;:e2a49a ratio;:e288b6 rationals;:e2849a rbarr;:e2a48d rbbrk;:e29db3 rbrace;:7d rbrack;:5d rbrke;:e2a68c rbrksld;:e2a68e rbrkslu;:e2a690 rcaron;:c599 rcedil;:c597 rceil;:e28c89 rcub;:7d rcy;:d180 rdca;:e2a4b7 rdldhar;:e2a5a9 rdquo;:e2809d rdquor;:e2809d rdsh;:e286b3 real;:e2849c realine;:e2849b realpart;:e2849c reals;:e2849d rect;:e296ad reg:c2ae reg;:c2ae rfisht;:e2a5bd rfloor;:e28c8b rfr;:f09d94af rhard;:e28781 rharu;:e28780 rharul;:e2a5ac rho;:cf81 rhov;:cfb1 rightarrow;:e28692 rightarrowtail;:e286a3 rightharpoondown;:e28781 rightharpoonup;:e28780 rightleftarrows;:e28784 rightleftharpoons;:e2878c rightrightarrows;:e28789 rightsquigarrow;:e2869d rightthreetimes;:e28b8c ring;:cb9a risingdotseq;:e28993 rlarr;:e28784 rlhar;:e2878c rlm;:e2808f rmoust;:e28eb1 rmoustache;:e28eb1 rnmid;:e2abae roang;:e29fad roarr;:e287be robrk;:e29fa7 ropar;:e2a686 ropf;:f09d95a3 roplus;:e2a8ae rotimes;:e2a8b5 rpar;:29 rpargt;:e2a694 rppolint;:e2a892 rrarr;:e28789 rsaquo;:e280ba rscr;:f09d9387 rsh;:e286b1 rsqb;:5d rsquo;:e28099 rsquor;:e28099 rthree;:e28b8c rtimes;:e28b8a rtri;:e296b9 rtrie;:e28ab5 rtrif;:e296b8 rtriltri;:e2a78e ruluhar;:e2a5a8 rx;:e2849e sacute;:c59b sbquo;:e2809a sc;:e289bb scE;:e2aab4 scap;:e2aab8 scaron;:c5a1 sccue;:e289bd sce;:e2aab0 scedil;:c59f scirc;:c59d scnE;:e2aab6 scnap;:e2aaba scnsim;:e28ba9 scpolint;:e2a893 scsim;:e289bf scy;:d181 sdot;:e28b85 sdotb;:e28aa1 sdote;:e2a9a6 seArr;:e28798 searhk;:e2a4a5 searr;:e28698 searrow;:e28698 sect:c2a7 sect;:c2a7 semi;:3b seswar;:e2a4a9 setminus;:e28896 setmn;:e28896 sext;:e29cb6 sfr;:f09d94b0 sfrown;:e28ca2 sharp;:e299af shchcy;:d189 shcy;:d188 shortmid;:e288a3 shortparallel;:e288a5 shy:c2ad shy;:c2ad sigma;:cf83 sigmaf;:cf82 sigmav;:cf82 sim;:e288bc simdot;:e2a9aa sime;:e28983 simeq;:e28983 simg;:e2aa9e simgE;:e2aaa0 siml;:e2aa9d simlE;:e2aa9f simne;:e28986 simplus;:e2a8a4 simrarr;:e2a5b2 slarr;:e28690 smallsetminus;:e28896 smashp;:e2a8b3 smeparsl;:e2a7a4 smid;:e288a3 smile;:e28ca3 smt;:e2aaaa smte;:e2aaac smtes;:e2aaacefb880 softcy;:d18c sol;:2f solb;:e2a784 solbar;:e28cbf sopf;:f09d95a4 spades;:e299a0 spadesuit;:e299a0 spar;:e288a5 sqcap;:e28a93 sqcaps;:e28a93efb880 sqcup;:e28a94 sqcups;:e28a94efb880 sqsub;:e28a8f sqsube;:e28a91 sqsubset;:e28a8f sqsubseteq;:e28a91 sqsup;:e28a90 sqsupe;:e28a92 sqsupset;:e28a90 sqsupseteq;:e28a92 squ;:e296a1 square;:e296a1 squarf;:e296aa squf;:e296aa srarr;:e28692 sscr;:f09d9388 ssetmn;:e28896 ssmile;:e28ca3 sstarf;:e28b86 star;:e29886 starf;:e29885 straightepsilon;:cfb5 straightphi;:cf95 strns;:c2af sub;:e28a82 subE;:e2ab85 subdot;:e2aabd sube;:e28a86 subedot;:e2ab83 submult;:e2ab81 subnE;:e2ab8b subne;:e28a8a subplus;:e2aabf subrarr;:e2a5b9 subset;:e28a82 subseteq;:e28a86 subseteqq;:e2ab85 subsetneq;:e28a8a subsetneqq;:e2ab8b subsim;:e2ab87 subsub;:e2ab95 subsup;:e2ab93 succ;:e289bb succapprox;:e2aab8 succcurlyeq;:e289bd succeq;:e2aab0 succnapprox;:e2aaba succneqq;:e2aab6 succnsim;:e28ba9 succsim;:e289bf sum;:e28891 sung;:e299aa sup1:c2b9 sup1;:c2b9 sup2:c2b2 sup2;:c2b2 sup3:c2b3 sup3;:c2b3 sup;:e28a83 supE;:e2ab86 supdot;:e2aabe supdsub;:e2ab98 supe;:e28a87 supedot;:e2ab84 suphsol;:e29f89 suphsub;:e2ab97 suplarr;:e2a5bb supmult;:e2ab82 supnE;:e2ab8c supne;:e28a8b supplus;:e2ab80 supset;:e28a83 supseteq;:e28a87 supseteqq;:e2ab86 supsetneq;:e28a8b supsetneqq;:e2ab8c supsim;:e2ab88 supsub;:e2ab94 supsup;:e2ab96 swArr;:e28799 swarhk;:e2a4a6 swarr;:e28699 swarrow;:e28699 swnwar;:e2a4aa szlig:c39f szlig;:c39f target;:e28c96 tau;:cf84 tbrk;:e28eb4 tcaron;:c5a5 tcedil;:c5a3 tcy;:d182 tdot;:e2839b telrec;:e28c95 tfr;:f09d94b1 there4;:e288b4 therefore;:e288b4 theta;:ceb8 thetasym;:cf91 thetav;:cf91 thickapprox;:e28988 thicksim;:e288bc thinsp;:e28089 thkap;:e28988 thksim;:e288bc thorn:c3be thorn;:c3be tilde;:cb9c times:c397 times;:c397 timesb;:e28aa0 timesbar;:e2a8b1 timesd;:e2a8b0 tint;:e288ad toea;:e2a4a8 top;:e28aa4 topbot;:e28cb6 topcir;:e2abb1 topf;:f09d95a5 topfork;:e2ab9a tosa;:e2a4a9 tprime;:e280b4 trade;:e284a2 triangle;:e296b5 triangledown;:e296bf triangleleft;:e29783 trianglelefteq;:e28ab4 triangleq;:e2899c triangleright;:e296b9 trianglerighteq;:e28ab5 tridot;:e297ac trie;:e2899c triminus;:e2a8ba triplus;:e2a8b9 trisb;:e2a78d tritime;:e2a8bb trpezium;:e28fa2 tscr;:f09d9389 tscy;:d186 tshcy;:d19b tstrok;:c5a7 twixt;:e289ac twoheadleftarrow;:e2869e twoheadrightarrow;:e286a0 uArr;:e28791 uHar;:e2a5a3 uacute:c3ba uacute;:c3ba uarr;:e28691 ubrcy;:d19e ubreve;:c5ad ucirc:c3bb ucirc;:c3bb ucy;:d183 udarr;:e28785 udblac;:c5b1 udhar;:e2a5ae ufisht;:e2a5be ufr;:f09d94b2 ugrave:c3b9 ugrave;:c3b9 uharl;:e286bf uharr;:e286be uhblk;:e29680 ulcorn;:e28c9c ulcorner;:e28c9c ulcrop;:e28c8f ultri;:e297b8 umacr;:c5ab uml:c2a8 uml;:c2a8 uogon;:c5b3 uopf;:f09d95a6 uparrow;:e28691 updownarrow;:e28695 upharpoonleft;:e286bf upharpoonright;:e286be uplus;:e28a8e upsi;:cf85 upsih;:cf92 upsilon;:cf85 upuparrows;:e28788 urcorn;:e28c9d urcorner;:e28c9d urcrop;:e28c8e uring;:c5af urtri;:e297b9 uscr;:f09d938a utdot;:e28bb0 utilde;:c5a9 utri;:e296b5 utrif;:e296b4 uuarr;:e28788 uuml:c3bc uuml;:c3bc uwangle;:e2a6a7 vArr;:e28795 vBar;:e2aba8 vBarv;:e2aba9 vDash;:e28aa8 vangrt;:e2a69c varepsilon;:cfb5 varkappa;:cfb0 varnothing;:e28885 varphi;:cf95 varpi;:cf96 varpropto;:e2889d varr;:e28695 varrho;:cfb1 varsigma;:cf82 varsubsetneq;:e28a8aefb880 varsubsetneqq;:e2ab8befb880 varsupsetneq;:e28a8befb880 varsupsetneqq;:e2ab8cefb880 vartheta;:cf91 vartriangleleft;:e28ab2 vartriangleright;:e28ab3 vcy;:d0b2 vdash;:e28aa2 vee;:e288a8 veebar;:e28abb veeeq;:e2899a vellip;:e28bae verbar;:7c vert;:7c vfr;:f09d94b3 vltri;:e28ab2 vnsub;:e28a82e28392 vnsup;:e28a83e28392 vopf;:f09d95a7 vprop;:e2889d vrtri;:e28ab3 vscr;:f09d938b vsubnE;:e2ab8befb880 vsubne;:e28a8aefb880 vsupnE;:e2ab8cefb880 vsupne;:e28a8befb880 vzigzag;:e2a69a wcirc;:c5b5 wedbar;:e2a99f wedge;:e288a7 wedgeq;:e28999 weierp;:e28498 wfr;:f09d94b4 wopf;:f09d95a8 wp;:e28498 wr;:e28980 wreath;:e28980 wscr;:f09d938c xcap;:e28b82 xcirc;:e297af xcup;:e28b83 xdtri;:e296bd xfr;:f09d94b5 xhArr;:e29fba xharr;:e29fb7 xi;:cebe xlArr;:e29fb8 xlarr;:e29fb5 xmap;:e29fbc xnis;:e28bbb xodot;:e2a880 xopf;:f09d95a9 xoplus;:e2a881 xotime;:e2a882 xrArr;:e29fb9 xrarr;:e29fb6 xscr;:f09d938d xsqcup;:e2a886 xuplus;:e2a884 xutri;:e296b3 xvee;:e28b81 xwedge;:e28b80 yacute:c3bd yacute;:c3bd yacy;:d18f ycirc;:c5b7 ycy;:d18b yen:c2a5 yen;:c2a5 yfr;:f09d94b6 yicy;:d197 yopf;:f09d95aa yscr;:f09d938e yucy;:d18e yuml:c3bf yuml;:c3bf zacute;:c5ba zcaron;:c5be zcy;:d0b7 zdot;:c5bc zeetrf;:e284a8 zeta;:ceb6 zfr;:f09d94b7 zhcy;:d0b6 zigrarr;:e2879d zopf;:f09d95ab zscr;:f09d938f zwj;:e2808d zwnj;:e2808c",named," ");for(i=1;i<=count;i++){split(named[i],pair,":");entity[pair[1]]=pair[2];if(length(pair[1])>entity_max)entity_max=length(pair[1])}
  numeric[128]=8364;numeric[130]=8218;numeric[131]=402;numeric[132]=8222;numeric[133]=8230;numeric[134]=8224;numeric[135]=8225;numeric[136]=710;numeric[137]=8240;numeric[138]=352;numeric[139]=8249;numeric[140]=338;numeric[142]=381;numeric[145]=8216;numeric[146]=8217;numeric[147]=8220;numeric[148]=8221;numeric[149]=8226;numeric[150]=8211;numeric[151]=8212;numeric[152]=732;numeric[153]=8482;numeric[154]=353;numeric[155]=8250;numeric[156]=339;numeric[158]=382;numeric[159]=376
}
{ document=document $0 "\n" }
END {
  images(filtered_prose(document))
  for(i=1;i<=uses;i++) {
    raw=original[i]
    if(kind[i]=="R") {
      id=reference_id[i]
      if(!(id in defined)){print "M\t" as_hex(raw) "\t-";continue}
      raw=definitions_url[id]
    }
    if(i in logical_source)decoded=address(logical_source[i],1,1);else decoded=address(raw,html_attribute[i],0)
    print (invalid?"X":"S") "\t" as_hex(raw) "\t" as_hex(decoded)
  }
}
' 2> /dev/null)" || image_status=$?
if [ "$image_status" -ne 0 ]; then
  reported=1
  printf '%s\n' 'readme.sh: README.md: could not complete the image inspection. Check that this file is readable and the local text tools run, then run checks/readme.sh from the product root.' >&2
  exit 1
fi
while IFS=$'\t' read -r kind original_hex decoded_hex; do
  [ -n "$kind" ] || continue
  original=''; decoded=''
  [ "$original_hex" = - ] || original="$(unhex "$original_hex")"
  [ "$decoded_hex" = - ] || decoded="$(unhex "$decoded_hex")"
  if [ "$kind" = M ]; then
    printf 'readme.sh: README.md: image reference has no definition: %s. Define it with a repository-relative path to a present tracked image file inside this repository, then run checks/readme.sh from the product root.\n' "$original" >&2
    findings=1
    continue
  fi
  inspection_status=1
  if [ "$kind" = S ]; then
    inspection_status=0
    repository_file "$decoded" "$root" "$tracked" || inspection_status=$?
  fi
  case "$inspection_status" in
    0) ;;
    1) printf 'readme.sh: README.md: image source does not name a present tracked file inside this repository: %s. Use a repository-relative path to a present tracked image file inside this repository, then run checks/readme.sh from the product root.\n' "$original" >&2; findings=1;;
    *) printf 'readme.sh: README.md: could not inspect image source: %s. Check the referenced path and Git\047s tracked file list, then run checks/readme.sh from the product root.\n' "$original" >&2; findings=1;;
  esac
done < <(printf '%s\n' "$image_records")
reported=1
exit "$findings"
