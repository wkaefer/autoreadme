MAKEFLAGS=-s
PREFIX=${HOME}
W=autoreadme

.PHONY: install

.DEFAULT:
	@:

LIST="{autoreadme,bkup,i2ico,hr,b4markdown,qutopia,txt2image}"

all:
	@:
#	@printf "\033[32;1m%32.32s\033[0m\n" $W

test:
	generate_table
	generate_table | merge_table
	@generate_files
	@generate_html
	@checkreadme

install:
	@make install_ignore_list
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Either add `pwd` to your path or install at least autoreadme to ~/bin";\
		echo " Error: No program specified.";\
		echo "  Usage: make install <program_name>";\
		echo "   Where program name is in ${LIST}";\
		echo "    Use install_all to install all programs";\
		exit 1;\
	fi
	@case "$(filter-out $@,$(MAKECMDGOALS))" in \
		autoreadme|bkup|i2ico|hr|b4markdown|txt2image|qutopia) :;;\
		*) echo "Error: program name must be in ${LIST}";exit 1;;\
	esac
#	@echo "Installing $(filter-out $@,$(MAKECMDGOALS))..."
	@L=`realpath --relative-to=${PREFIX}/bin $(filter-out $@,$(MAKECMDGOALS))` && \
		ln -snf $$L ${PREFIX}/bin/ && printf "\033[36;1m%42.42s\033[0m\n" $$L
#	@ln -vsnf `realpath --relative-to=${PREFIX}/bin $(filter-out $@,$(MAKECMDGOALS))` ${PREFIX}/bin/
#	@echo "Installation complete for $(filter-out $@,$(MAKECMDGOALS))! 🌵"


install_ignore_list::
	@mkdir -vp ${HOME}/.config/autoreadme
	@I="${HOME}/.config/autoreadme/ignore_list.txt";\
	if [ ! -f "$$I" ] ; then \
		printf "\033[36;1m%42.42s\033[0m\n" "~$${I##*${HOME}}"; \
		cp ignore_list.txt "$$I";\
	fi

install_all:
	@for p in autoreadme bkup i2ico hr b4markdown qutopia txt2image; do make install $$p; done
	@+make install_ignore_list


clean:
	@true

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
	git remote add github https://www.github.com/${GITHUB_NAME}/autoreadme.git 
	git remote set-url github git@github.com:${GITHUB_NAME}/autoreadme.git

reset: __reset
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
