Du point de vue du professeur, c'est la quantité inconnue $p$ qui est
intérssante : elle représente le niveau du candidat. Il s'agit donc
d'estimer $p$ à partir de la note obtenue au QCM.

On peut utiliser le théorème de Bayes pour y parvenir : pour se ramener
dans le cadre des probabilités finies, on suppose que le paramètre $p$
ne prend qu'un nombre fini de valeurs : $p = \frac{k}{n}$ pour
$k \\in \{0,1,\\dots,n\}$ et on fait l'hypothèse qu' \*a priori\* ces
valeurs sont équiprobables. (Il est tout à fait possible de tester
d'autres distributions !)

En notant $N$ la note obtenue, $t$ le nombre total de questions, la
formule de Bayes donne alors
$$\forall k, P_{N=x}(p=k/n) = \frac{1}{\sum_{j=0}^n \binom{t}{x} \\left(\frac{j}{n}\\right)^x \left(1-\frac{j}{n}\right)^{t-x}   } \binom{t}{x} \left(\frac{k}{n}\right)^x \\left(1-\frac{k}{n}\right)^{t-x}.$$

Le graphique ci-dessous représente ces différentes probabilités.
