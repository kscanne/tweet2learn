
all: template.html lang/*.txt build.pl
	rm -Rf distro
	mkdir distro
	ls lang/*.txt | sed 's/^lang.//' | sed 's/\.txt//' | while read x; do cat lang/$$x.txt | perl build.pl "`egrep '^name_native' /usr/local/share/crubadan/$$x/EOLAS | sed 's/^[^ ]* *//'`" > abhar.html; mkdir -p distro/$$x; sed '/^<body/r abhar.html' template.html | sed "s/ACCORDIONS/`egrep -o 'acc[0-9]+' abhar.html | sort -u | wc -l`/" > distro/$$x/index.html; rm -f abhar.html; done

dist distt2l.zip: FORCE
	rm -f distt2l.zip
	(cd distro; zip -r distt2l.zip *; mv distt2l.zip ..)
	sftp -b pushfile kscanne@indigenoustweets.com
	ssh kscanne@indigenoustweets.com 'unzip -o -d html/tweet2learn distt2l.zip'

clean:
	rm -f index.html abhar.html distt2l.zip
	rm -Rf distro

FORCE:
