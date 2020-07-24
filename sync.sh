#!/bin/sh

#======================================Vars
export autor='Jefferson Carneiro'
export EDITOR='nano'

#======================================Teste
[ ! -d "post/" ] && { mkdir -v post/ ;} # diretorio post existe?

#======================================FUNCOES
POST() # POSTAGEM
{
  post_date=$(date +%d/%m/%y)
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

<hr>
<footer style="text-align: center;">
	Copyright (c) 2020 <a href="https://slackjeff.com.br">slackjeff</a>.
</footer>
</body>
</html>
EOF
  # Abrindo artigo
  $EDITOR "post/${_ano}/${_mes}/${urlName}.html"
}

INSERT()
{
    # Inserindo no index
    printf '%s\n' "Inserindo no INDEX."
    sleep 1s
    sed -i "/<ul id='post'>/a <li><a href="post/${_ano}/${_mes}/${urlName}.html">$postName</a></li>" index.html
}

GIT()
{
  git add *
  read -p "Comentário das alterações: " comment
  git commit -m "$comment"
  git push
}
#======================= INICIO
POST
INSERT
GIT
