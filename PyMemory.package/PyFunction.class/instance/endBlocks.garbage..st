action
endBlocks: aNumber garbage: uncollectNum
"Add the number of memory blocks after the function is executed and the number of uncollected objects"

	| assoc |
	assoc := stack pop.
	blocks add: (assoc key -> aNumber).
	uncollected add: (assoc value -> uncollectNum).
	
	

	