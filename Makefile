serve:
	gitbook serve --log=debug --debug --no-live
refine:
	python3 scripts/subdirectory_summary.py --site-dir .
	cp _book/assets/favicon.ico _book/gitbook/images/favicon.ico
