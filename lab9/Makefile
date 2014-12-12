FILE = QuizCode.c
LOGFILE = perf.log

SORT = QuizCode_sort
NOSORT = QuizCode_nosort

CC = @gcc -Wall -std=c99 -O3

entry: test
	@echo "Done"
	@cat $(LOGFILE)

no-sort:
	 $(CC) $(FILE) -USORTING -o $(NOSORT) 

sort:
	 $(CC) $(FILE) -DSORTING -o $(SORT) 

test: no-sort sort
	@echo "Testing started!"
	@rm -rf perf.log
	@echo "Testing without sort..."
	@perf stat --big-num -e cache-misses -e branch-misses --append -o $(LOGFILE) ./$(NOSORT)
	@echo "Testing with sort..."
	@perf stat --big-num -e cache-misses -e branch-misses --append -o $(LOGFILE) ./$(SORT)


clean: entry
	@rm -rf $(NOSORT)
	@rm -rf $(SORT)

