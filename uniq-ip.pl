# muestra ips únicas aparecidas en la entrada
perl -nle 'print for grep { !$seen{$_}++ } /(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b)/g'
