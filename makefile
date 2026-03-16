W=autoreadme

all:
	@printf "\033[32;1m%32.32s\033[0m\n" $W

test:
	generate_table
	generate_table | merge_table
	@generate_files
	@generate_html
	@checkreadme

install:
	@[ -d ../../bin ] && \
		ln -snf ../misc/$W/$W ../../bin/$W && printf "\033[33;1m%32.32s\033[0m\n" ../../bin/$W ||\
		echo Create a Link in PATH to $W or create alias
clean:
	@true

tar:
	make
	tar -czvf readme.tar.gz \
		README.md .readme.html .header.html \
		.htaccess .contents .info \
		generate_table merge_table \
		generate_files generate_html checkreadme

test0:
	mkdir -p tmp
	generate_table	
	generate_table | merge_table

test_ignore:
	echo "# This is a Environment Variable Ignore List" > .ignore_list.txt
	IGNORE_LIST=`pwd`/.ignore_list.txt python ./ignore_list.py
	rm -f ./.ignore_list.txt
	mkdir -p ~/.config/autoreadme
	sed 's/Default/Users/' < ignore_list.txt > ~/.config/autoreadme/ignore_list.txt
	python ./ignore_list.py 
	rm -f ~/.config/autoreadme/ignore_list.txt
	python ./ignore_list.py 
	P=`pwd`;sh -c "cd /tmp && python $$P/ignore_list.py"


#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/**--__
#      ____ ___ _____      __   ____ ___ _____ _   _ _   _ ____  
#     / ___|_ _|_   _|    / /  / ___|_ _|_   _| | | | | | | __ ) 
#    | |  _ | |  | |     / /  | |  _ | |  | | | |_| | | | |  _ \ 
#    | |_| || |  | |    / /   | |_| || |  | | |  _  | |_| | |_) |
#     \____|___| |_|   /_/     \____|___| |_| |_| |_|\___/|____/ 
#                                                                

github:
	git push github main
	
__reset::
	rm -rf .git
	git init
	git remote add origin git@shazam:/srv/git/autoreadme
	git remote add github https://www.github.com/wkaefer/autoreadme.git 
	git remote set-url github git@github.com:wkaefer/autoreadme.git

reset:
	git fetch 
	git checkout origin/main -ft
	git config pull.rebase false
	git status

__reset_git_repo__: __reset
	ssh git@localhost rm -rf /srv/git/autoreadme.git
	ssh git@localhost mkdir /srv/git/autoreadme.git
	ssh git@localhost git -C /srv/git/autoreadme.git init --bare --initial-branch=main
	git add .
	git commit -m "Initial commit"
	git push -u origin main

# vim: set ft=make ts=8 sw=8 noet :
