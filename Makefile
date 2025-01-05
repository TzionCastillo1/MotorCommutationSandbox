CLEANUP=rm -f
MKDIR=mkdir -p
TARGET_EXTENSION=out

.PHONY: clean
.PHONY: test

PATHU = vendor/Unity/src/
PATHS = src/
PATHE = src/example/
PATHT = test/
PATHB = build/
PATHD = build/depends/
PATHO = build/objs/
PATHR = build/results/

BUILD_PATHS = $(PATHB) $(PATHD) $(PATHO) $(PATHR)

SRCT = $(wildcard $(PATHT)*.c)

COMPILE=gcc -c 
LINK=gcc
DEPEND=gcc -MM -MG -MF
CFLAGS=-I. -I$(PATHU) -I$(PATHS) -I$(PATHE) -DTEST

RESULTS = $(patsubst $(PATHT)Test%.c,$(PATHR)Test%.txt,$(SRCT))

test: $(BUILD_PATHS) $(RESULTS)
	@echo "---------------\nPASSES:\n-----------------"
	@echo `grep -s PASS $(PATHR)*.txt`
	@echo "---------------\nIGNORES:\n----------------"
	@echo `grep -s IGNORE $(PATHR)*.txt`
	@echo "----------------\nFAILURES:\n--------------"
	@echo `grep -s FAIL $(PATHR)*.txt`
	@echo "\nDONE"

$(PATHR)%.txt: $(PATHB)%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

$(PATHB)Test%.$(TARGET_EXTENSION): $(PATHO)Test%.o $(PATHO)%.o $(PATHO)unity.o #$(PATHD)Test%.d
	$(LINK) -o $@ $^

$(PATHO)%.o:: $(PATHT)%.c 
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHS)%.c 
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHE)%.c 
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHO)%.o:: $(PATHU)%.c $(PATHU)%.h 
	$(COMPILE) $(CFLAGS) $< -o $@

$(PATHD)%.d:: $(PATHT)%.c 
	$(DEPEND) $@ $<

$(PATHB): 
	$(MKDIR) $(PATHB)

$(PATHD): 
	$(MKDIR) $(PATHD)

$(PATHO): 
	$(MKDIR) $(PATHO)
	
$(PATHR): 
	$(MKDIR) $(PATHR)

clean:
	$(CLEANUP) $(PATHO)*.o
	$(CLEANUP) $(PATHB)*.$(TARGET_EXTENSION)
	$(CLEANUP) $(PATHR)*.txt

.PRECIOUS: $(PATHB)Test%.$(TARGET_EXTENSION)
.PRECIOUS: $(PATHD)%.d 
.PRECIOUS: $(PATHO)%.o 
.PRECIOUS: $(PATHR)%.txt 


