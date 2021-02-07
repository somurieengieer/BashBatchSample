#!/bin/bash -eu

readonly INPUT_FILE='input.csv'
readonly OUTPUT_FILE='output.dat'

# ファイルが存在する場合クリアする
> ${OUTPUT_FILE}

cat "./${INPUT_FILE}" | while IFS=, read -r id name age country
do
  # IDは0詰め3桁表示
  out_line=`printf %03d ${id}`

  # 名前は全角5桁とし、超過した分は右側をカット。5桁以下のものは右側にスペースを詰める
  name_count=`echo -n ${name} | wc -m`
  # name_count=`${#name}` # こんな書き方もできる
  if [ $name_count -ge 5 ]; then
    out_line+="`echo $name | cut -c 1-5`"
  else
    name="${name}　　　　　"
    out_line+=${name:0:5} # 右側に全角ブランクを詰めて0文字目から5文字目をトリミング
  fi

  # 半角スペースを3桁挿入する
  out_line+="$(printf '%3s')"   # 半角スペースが消えないように""で括る

  # 年齢は3桁半角スペース詰め
  out_line+="`printf %3d ${age}`"   # 半角スペースが消えないように""で括る

  # ""で括ることで行頭・行末に存在する半角スペースもファイルに出力する
  echo "${out_line}" >> ./${OUTPUT_FILE}
done

