MAKEFLAGS=-s
PREFIX=${HOME}/.local
MANPREFIX=${PREFIX}/share/man
W=autoreadme

.PHONY: install
.ONESHELL:
.DEFAULT:
	@:

P=autoreadme bkup i2ico hr b4markdown qutopia txt2image

all:
	@:
#	@printf "\033[32;1m%32.32s\033[0m\n" $W

test:
	generate_table
	generate_table | merge_table
	@generate_files
	@generate_html
	@checkreadme

# ToDo: autoreadme needs something in share/autoreadme
# ToDo: qutopia needs an image in share/qutopia/...
install: install-man
	@mkdir -p "${PREFIX}/bin" "${PREFIX}/share/autoreadme" "${HOME}/.config/autoreadme"
	@cp -v autoreadme b4markdown bkup checkreadme "${PREFIX}/share/autoreadme/"
	@cp -v generate_files generate_html generate_table "${PREFIX}/share/autoreadme/"
	@cp -v hr i2ico "${PREFIX}/share/autoreadme/"
	@cp -v markdown.css merge_table mkimageindex qutopia recycle.jpg "${PREFIX}/share/autoreadme/"
	@cp -v txt2image "${PREFIX}/share/autoreadme/"
	@cp -v ignore_list.py ignore_list.txt ignore_htaccess.txt "${PREFIX}/share/autoreadme/"
	@mkdir -p "${HOME}/.config/qutopia"
	@test -f "${HOME}/.config/autoreadme/README.md" || \
	 cat <<-'EOF' > "${HOME}/.config/autoreadme/README.md"
	 # AutoReadme #
	 
	 Autoreadme optional configuration
	 
	 ## Files ##
	 
	 | File                 | 🧿 | Description                                   |
	 |----------------------|----|-----------------------------------------------|
	 | ignore_list.txt      | 📃 | Default Ignore List installed from autoreadme |
	 | ignore_htaccess.txt  | 📃 | Sample .htaccess-only ignore pattern list     |
	 EOF
	@test -f "${HOME}/.config/autoreadme/ignore_list.txt" || \
	 cp -v ignore_list.txt "${HOME}/.config/autoreadme/"
	@test -f "${HOME}/.config/autoreadme/ignore_htaccess.txt" || \
	 cp -v ignore_htaccess.txt "${HOME}/.config/autoreadme/"
	@ln -svnf ../share/autoreadme/autoreadme ${PREFIX}/bin/autoreadme

clean:
	@rm -rf __pycache__

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

# vim: set ft=make ts=8 sw=8 noet :
