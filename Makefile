

run: index rowdy 
	open http://localhost:8080
	php -S localhost:8080

index: index.html

rowdy: rowdy.html

repo:
	open https://github.com/btschwartz12/btschwartz12.github.io


# Remove automatically generated files
clean :
	rm -rvf *.exe *~ *.out *.DS_Store *.stackdump



