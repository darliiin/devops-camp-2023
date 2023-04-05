
#!/bin/bash
#check for a valid number of arguments
if [[ "$#" != 2 ]]; then
  echo "Enter two arguments"
  exit 1
fi
#check if file exists
for file in "$@"; do
  #if the file does not exist
  if [[ ! -f "$file" ]]; then
    rstring=$(openssl rand -base64 8)
    echo "$rstring" | base64 > "$file"
    chmod 700 "$file"
    echo "new file: $file"
  #if the file exists
  else
    echo "$file:"
    cat "$file"
    echo ""
  fi
done

