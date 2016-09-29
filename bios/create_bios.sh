#!/bin/bash

template="template.html"
prev=#
next=#
cur=#
bios="./*.bio"
index=0
separators=("NOM" "BIO" "WEB" "FB" "MAIL" "INSTA" "YTBE" "IMAGE")

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
        ytbe=""
        image=""
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
                        "YTBE") ytbe="$ytbe $word" ;;
                        "IMAGE") image="$image $word" ;;
                        *) ;;
                    esac
                fi
            done
        done < $prevbio
        
        linkstemplate="<div class=\"table\"> WEB MAIL FB INSTA YTBE</div>"
        fbtemplate="<div class=\"text\"><a target=\"_blank\" href=\"FB\" class=\"facebook\"><h3><i class=\"fa fa-facebook\"></i></h3></a></div>"
        mailtemplate="<div class=\"text\"><a target=\"_blank\" href=\"mailto:MAIL\" class=\"mail\"><h3><i class=\"fa fa-envelope\"></i></h3></a></div>"
        webtemplate="<div class=\"text\"><a target=\"_blank\" href=\"WEB\" class=\"web\"><h3><i class=\"fa fa-globe\"></i></h3></a></div>"
        instatemplate="<div class=\"text\"><a target=\"_blank\" href=\"INSTA\" class=\"insta\"><h3><i class=\"fa fa-instagram\"></i></h3></a></div>"
        ytbetemplate="<div class=\"text\"><a target=\"_blank\" href=\"YTBE\" class=\"ytbe\"><h3><i class=\"fa fa-youtube-play\"></i></h3></a></div>"
        imagetemplate="<div class=\"photo\"><p></br></p><img src=\"IMAGE\"/></div>"
        
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
        if [[ ! -z "${ytbe// }" ]]
        then
            ytbetemplate="${ytbetemplate/YTBE/$ytbe}"
            ytbe=$ytbetemplate
        else
            ytbe="   "
        fi
        if [[ ! -z "${image// }" ]]
        then
            imagetemplate="${imagetemplate/IMAGE/$image}"
            image=$imagetemplate
        else
            image="   "
        fi
        
        linkstemplate="${linkstemplate/WEB/$web}"
        linkstemplate="${linkstemplate/MAIL/$mail}"
        linkstemplate="${linkstemplate/FB/$fb}"
        linkstemplate="${linkstemplate/INSTA/$insta}"
        linkstemplate="${linkstemplate/YTBE/$ytbe}"
        
        sed -i "s#LINKS#$linkstemplate#g" $cur
        sed -i "s#IMAGE#$image#g" $cur
        
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