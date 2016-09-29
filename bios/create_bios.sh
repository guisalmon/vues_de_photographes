#!/bin/bash

template="template.html"
prev=#
next=#
cur=#
bios="./*.bio"
index=0
separators=("NOM" "BIO" "WEB" "FB" "MAIL" "INSTA")

for bio in $bios
do
    cur=$next
    next="${bio%.*}"
    next="$next.html"
    if (( $index > 0 ))
    then
        cp $template $cur
        separator=""
        name=""
        text=""
        web=""
        fb=""
        mail=""
        insta=""
        while read line
        do
            for word in $line
            do
                if [[ " ${separators[@]} " =~ " ${word} " ]]
                then
                    separator=$word
                else
                    case $separator in
                        "NOM") name="$name $word" ;;
                        "BIO") text="$text $word" ;;
                        "WEB") web="$web $word" ;;
                        "FB") fb="$fb $word" ;;
                        "INSTA") insta="$insta $word" ;;
                        "MAIL") mail="$mail $word" ;;
                        *) ;;
                    esac
                fi
            done
        done < $prevbio
        echo ""
        echo $name
        echo $text
        echo $web
        echo $fb
        echo $mail
        echo $insta
        
        linkstemplate="<div class=\"table\"> WEB MAIL FB INSTA </div>"
        fbtemplate="<div class=\"text\"><a target=\"_blank\" href=\"FB\" class=\"facebook\"><h3><i class=\"fa fa-facebook\"></i></h3></a></div>"
        mailtemplate="<div class=\"text\"><a target=\"_blank\" href=\"mailto:MAIL\" class=\"mail\"><h3><i class=\"fa fa-envelope\"></i></h3></a></div>"
        webtemplate="<div class=\"text\"><a target=\"_blank\" href=\"WEB\" class=\"web\"><h3><i class=\"fa fa-globe\"></i></h3></a></div>"
        instatemplate="<div class=\"text\"><a target=\"_blank\" href=\"INSTA\" class=\"insta\"><h3><i class=\"fa fa-instagram\"></i></h3></a></div>"
        
        if [[ ! -z "${web// }" ]]
        then
            webtemplate="${webtemplate/WEB/$web}"
            web=$webtemplate
        else
            web="   "
        fi
        if [[ ! -z "${mail// }" ]]
        then
            mailtemplate="${mailtemplate/MAIL/$mail}"
            mail=$mailtemplate
        else
            mail="   "
        fi
        if [[ ! -z "${fb// }" ]]
        then
            fbtemplate="${fbtemplate/FB/$fb}"
            fb=$fbtemplate
        else
            fb="   "
        fi
        if [[ ! -z "${insta// }" ]]
        then
            instatemplate="${instatemplate/INSTA/$insta}"
            insta=$instatemplate
        else
            insta="   "
        fi
        
        linkstemplate="${linkstemplate/WEB/$web}"
        linkstemplate="${linkstemplate/MAIL/$mail}"
        linkstemplate="${linkstemplate/FB/$fb}"
        linkstemplate="${linkstemplate/INSTA/$insta}"
        
        sed -i "s#LINKS#$linkstemplate#g" $cur
        
        sed -i "s@BIO@$text@g" $cur
        sed -i "s@NOM@$name@g" $cur
        sed -i "s@PREV@$prev@g" $cur
        sed -i "s@NEXT@$next@g" $cur
        
    fi
    prev=$cur
    index=$index+1
    prevbio=$bio
done
    
exit