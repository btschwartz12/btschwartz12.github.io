

run: index rowdy 
	open http://localhost:8080
	php -S localhost:8080

index: index.html index_script.js

rowdy: rowdy.html


# Remove automatically generated files
clean :
	rm -rvf *.exe *~ *.out *.DS_Store *.stackdump



