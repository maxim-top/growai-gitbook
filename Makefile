serve:
	gitbook serve --log=debug --debug --no-live
refine:
	docker run -t -w /gitbook -v `pwd`:/gitbook erlang:21  escript scripts/subdirectory_summary.escript
	cp _book/assets/favicon.ico _book/gitbook/images/favicon.ico
