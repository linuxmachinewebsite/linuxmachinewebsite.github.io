#!/bin/bash

#======================================Vars
export autor='Jefferson Carneiro'
export EDITOR='nano'
export url="https://linuxmachine.com"

#======================================Teste
[ ! -d "post/" ] && { mkdir -v post/ ;} # diretorio post existe?

#======================================FUNCOES
POST() # POSTAGEM
{
  post_date=$(date '+%d de %B de %Y')
  _mes=$(date +%m)
  _ano=$(date +%Y)
  
  # Criando estrutura para o post.
  mkdir -vp post/${_ano}/${_mes}
  
  # Criação de Url
  while [ -z "$urlName" ]; do
    printf '%s' "Digite a url: "
    read -e urlName
  done
  urlName=$(echo "$urlName" | sed 's/ /-/g') # Convertendo espaços por traços.
  
  # Criação do nome do post.
  while [ -z "$postName" ]; do
    printf '%s' "Digite o nome do post: "
    read -e postName
  done

  
cat << EOF > "post/${_ano}/${_mes}/${urlName}.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
	<title>${postName}</title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<meta name="author" content="$autor" />
	<meta name="description" content="${postName}">
	<meta name="keywords" content="Linux Machine, ${postName},">
	<meta name="generator" content="GNU/nano" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="../../../estilo.css">
</head>
<body>

<main>
	<a href="../../../">Voltar</a>
	<h1>$postName</h1>
	<h2>Autor: $autor</h2>
	<h3>Data: ${post_date}</h3>
<hr>

<p>POST AQUI</p>

<!-- ADS -->
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- Linux machine post -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1983636563768502"
     data-ad-slot="8975888692"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>

</main>

<footer>
	♥ Html+Css+Bash por: <a href="https://slackjeff.com.br">slackjeff</a>. Copyright © 2020
</footer>

</body>
</html>
EOF
  # Abrindo artigo
  $EDITOR "post/${_ano}/${_mes}/${urlName}.html"
}

INSERT()
{
    echo "Iserindo no index.html"
    # Inserindo no index
    printf '%s\n' "Inserindo no INDEX."
    sleep 1s
    sed -i "/<!-- Artigos -->/a <p><a href="post/${_ano}/${_mes}/${urlName}.html">${postName}</a> <small>${post_date}</small></p>" index.html
}

GIT()
{
  echo "Enviando para github."
  git add *
  read -ep "Comentário das alterações: " comment
  git commit -m "$comment"
  git push
}

FEED() # Enviando para o feed de noticias
{
  data="$(date)"
  read -ep "Escreva uma descrição para o FEED: " desc
  sed -i "/<\!--artigo-->/a <item>\n<title>$postName</title>\n<link>${url}/post/${_ano}/${_mes}/${urlName}.html</link>\n<pubDate>${data}</pubDate>\n<description>${desc}</description>\n</item>" linuxmachine.rss
  echo "Descrição inserida no feed."
}



#======================= INICIO
POST
INSERT
FEED
read -p "Enviar para o git? [S/n]: " rep
rep=${rep:=s}
rep=${rep,,}
if [[ "$rep" = 's' ]]; then
  GIT
else
  echo "Saindo..."
  exit 0
fi
