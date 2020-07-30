#!/bin/bash

#======================================Vars
export autor='Jefferson Carneiro'
export EDITOR='nano'
export url="https://linuxmachine.com.br"

#======================================Teste
[[ ! -d "post/" ]] && { mkdir -v post/ ;} # diretorio post existe?

#======================================FUNCOES
LOGO()
{
  clear
  cat <<EOF

  _ _                    __  __    _    ____ _   _ ___ _   _ _____ 
 | (_)_ __  _   ___  __ |  \/  |  / \  / ___| | | |_ _| \ | | ____|
 | | | '_ \| | | \ \/ / | |\/| | / _ \| |   | |_| || ||  \| |  _|  
 | | | | | | |_| |>  <  | |  | |/ ___ \ |___|  _  || || |\  | |___ 
 |_|_|_| |_|\__,_/_/\_\ |_|  |_/_/   \_\____|_| |_|___|_| \_|_____|
                                                                   
EOF
}

POST() # POSTAGEM
{
  post_date=$(date '+%d de %B de %Y')
  _mes=$(date +%m)
  _ano=$(date +%Y)

  # Criando estrutura para o post.
  mkdir -vp "post/${_ano}/${_mes}"

  # Criação de Url
  while [[ -z "$urlName" ]]; do
      echo -e "\n# Digite a URL da postagem!"
      read -e urlName
  done
  urlName=${urlName// /-} # Convertendo espaços por traços.
  urlName=${urlName//_/-} # Convertendo underlines por traços.
  urlName=${urlName,,}    # Maiusculo para minusculo.

  # Criação do nome do post.
  while [[ -z "$postName" ]]; do
      echo -e "\n#Digite o nome da postagem:"
      echo "# Use uma chamada CHAMATIVA!"
      read -e postName
  done

  # Criação da descrição da postagem no index
  while [[ -z "$giantdesc" ]]; do
      echo -e "\n# Descrição para postagem no index!"
      echo -e "\n# Faça uma descrição bem chamativa e que envolva a postagem."
      read -e giantdesc
  done

   while [[ -z "$tags" ]]; do
         echo "# Digite algumas tags relacionadas a postagem."
         echo "# Elas devem ser separadas/delimitadas por virgulas!"
         echo "# Exemplo: linux,terminal,como usar o comando apt,instalar programa apt"
         read -e tags
   done

cat << EOF > "post/${_ano}/${_mes}/${urlName}.html"
<!DOCTYPE html>
<html lang="pt-br">
<head>
	<title>${postName}</title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<meta name="author" content="$autor"/>
	<meta name="description" content="${giantdesc}">
	<meta name="keywords" content="Linux Machine, ${postName}, ${tags}">
	<meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="icon" href="../../../img/linuxmachine.png">
	<link rel="stylesheet" type="text/css" href="../../../estilo.css">
</head>
<body>
<div class="box-article">

<main>
	<a href="/">Voltar</a>
		<h1>$postName</h1>
	   <div class="descricao-postagem">
	      <img class="profile-image" src="/img/jefferson-carneiro.jpeg">
	      <b>$autor</b>
	      <time>${post_date}</time>
      </div>
<hr>

<!--
   ABAIXO VOCÊ DEVE INICIAR A POSTAGEM!
-->

<p>POST AQUI</p>

<!-- ADSENSE -->
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

<!-- SISTEMA DE COMENTÁRIO DISQUS -->
<div id="disqus_thread"></div>
<script>

/**
*  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
*  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/
/*
var disqus_config = function () {
this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
};
*/
(function() { // DON'T EDIT BELOW THIS LINE
var d = document, s = d.createElement('script');
s.src = 'https://linux-machine.disqus.com/embed.js';
s.setAttribute('data-timestamp', +new Date());
(d.head || d.body).appendChild(s);
})();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>

<footer>
	♥ Html+Css+Bash por: <a href="https://slackjeff.com.br">slackjeff</a>. Copyright © 2020
</footer>

</div>
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
    sed -i "/<!-- Artigos -->/a <li><a href="post/${_ano}/${_mes}/${urlName}.html">${postName}</a><br>${giantdesc}<br><time>${post_date}</time></li>\n" index.html
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
  read -ep "# Escreva uma descrição para o Feed de noticias: " desc
  sed -i "/<\!--artigo-->/a <item>\n<title>$postName</title>\n<link>${url}/post/${_ano}/${_mes}/${urlName}.html</link>\n<pubDate>${data}</pubDate>\n<description>${desc}</description>\n</item>" linuxmachine.xml
  echo "Descrição inserida no feed."
}

#======================= INICIO
LOGO
echo -e "O que você deseja fazer?\n"
PS3='> '
select x in 'Iniciar Postagem' 'Enviar para o servidor' 'Sair'; do
   case $x in
      'Iniciar Postagem')
         POST
         INSERT
         FEED
      ;;
      'Enviar para o servidor')
         GIT
      ;;
      'Sair') exit 0 ;;
   esac
done