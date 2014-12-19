LOGFILE = perf.log

SIMPLE = simple
TILE = tile
INIT = -UINIT_M
PERF =  -e L1-dcache-load-misses -e L1-dcache-store-misses

CC = @gcc -Wall 

entry: test
	@echo "Done"
	@cat $(LOGFILE)

simple:
	 $(CC) $(SIMPLE).c $(INIT) -o $(SIMPLE) 

tile:
	 $(CC) $(TILE).c $(INIT) -o $(TILE) 

test: tile simple
	@echo "Testing started!"
	@rm -rf perf.log
	@echo "Testing simple algorithm"
	@perf stat --big-num $(PERF) --append -o $(LOGFILE) ./$(SIMPLE)
	@echo "Testing with tiled algorithm"
	@perf stat --big-num $(PERF) --append -o $(LOGFILE) ./$(TILE)


clean: entry
	@rm -rf $(SIMPLE)
	@rm -rf $(TILE)

