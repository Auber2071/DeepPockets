#!/usr/bin/env bash

TABLENAME=symbols;
SYMBOL_DB_FILE="symbols"
STRING_SYMBOL_FILE="$PROJECT_DIR/BIPortableHD_XZ/Resource/func.list"
STRING_PROPERTY_FILE="$PROJECT_DIR/BIPortableHD_XZ/Resource/property.list"
STRING_CAT_FILE="$PROJECT_DIR/BIPortableHD_XZ/Resource/category.list"

CONFUSE_FILE="$PROJECT_DIR/BIPortableHD_XZ"

HEAD_FILE="$PROJECT_DIR/BIPortableHD_XZ/Resource/codeObfuscation.h"

export LC_CTYPE=C

#取以.m或.h结尾的文件以+号或-号开头的行 |去掉所有+号或－号|用空格代替符号|n个空格跟着<号 替换成 <号|开头不能是IBAction|用空格split字串取第二部分|排序|去重复|删除空行|删掉以init开头的行>写进func.list
grep -h -r -I  "^[-+]" $CONFUSE_FILE  --include '*.[mh]' |sed "s/[+-]//g"|sed "s/[();,: *\^\/\{]/ /g"|sed "s/[ ]*</</"| sed "/^[ ]*IBAction/d"|awk '{split($0,b," "); print b[2]; }'| sort|uniq |sed "/^$/d"|sed -n "/^BNC_/p" >$STRING_SYMBOL_FILE

grep -r -h -I  "^@property" $CONFUSE_FILE --include '*.[mh]' | sed "s/(.*)/ /g"  | sed "s/<.*>//g" |sed "s/[,*;]/ /g" | sed "s/IBOutlet/ /g" |awk '{split($0,s," ");print s[3];}'|sed "/^$/d"|sed -n "/^BNC_/p" | sort |uniq >$STRING_PROPERTY_FILE

grep -h -r -I  "^@interface" $CONFUSE_FILE --include '*.[mh]' | sed "s/[:(]/ /" |awk '{split($0,s," ");print s[2];}'|sed "/^$/d"|sed -n "/^BNC_/p" |sort|uniq >$STRING_CAT_FILE

#维护数据库方便日后作排重,一下代码来自念茜的微博
createTable()
{
echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue()
{
echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query()
{
echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

ramdomString()
{
openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16

}

rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable

touch $HEAD_FILE
echo '#ifndef Demo_codeObfuscation_h
#define Demo_codeObfuscation_h' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE


sqlite3 $SYMBOL_DB_FILE .dump;

