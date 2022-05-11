<p>Du point de vue du professeur, c’est la quantité inconnue <span
class="math inline"><em>p</em></span> qui est intérssante : elle
représente le niveau du candidat. Il s’agit donc d’estimer <span
class="math inline"><em>p</em></span> à partir de la note obtenue au
QCM.</p>
<p>On peut utiliser le théorème de Bayes pour y parvenir : pour se
ramener dans le cadre des probabilités finies, on suppose que le
paramètre <span class="math inline"><em>p</em></span> ne prend qu’un
nombre fini de valeurs : <span class="math inline">$p =
\frac{k}{n}$</span> pour <span class="math inline">$k \\in
\{0,1,\\dots,n\}$</span> et on fait l’hypothèse qu’ *a priori* ces
valeurs sont équiprobables. (Il est tout à fait possible de tester
d’autres distributions !)</p>
<p>En notant <span class="math inline"><em>N</em></span> la note
obtenue, <span class="math inline"><em>t</em></span> le nombre total de
questions, la formule de Bayes donne alors <span
class="math display">$$\forall k, P_{N=x}(p=k/n) = \frac{1}{\sum_{j=0}^n
\binom{t}{x} \\left(\frac{j}{n}\\right)^x
\left(1-\frac{j}{n}\right)^{t-x}   } \binom{t}{x}
\left(\frac{k}{n}\right)^x
\\left(1-\frac{k}{n}\right)^{t-x}.$$</span></p>
<p>Le graphique ci-dessous représente ces différentes probabilités.</p>
