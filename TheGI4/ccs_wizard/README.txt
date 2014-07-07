This is an interpreter for the "Calculus of Communicating Systems" (CCS).
It has been designed for compatibility with the Concurrent Programming Cource 2013 at Saarland University.


A demo video can be found at    http://www.youtube.com/watch?v=-cGXmsET4Q4   .


1.  *** What you need ***
	
	You need to have installed Moscow ML (http://www.itu.dk/people/sestoft/mosml.html) and Graphviz (http://www.graphviz.org/).
	On UNIX systems, these programs are automatically callable with by "mosml" and "dot".
	On Windows however, this may not be the case:
		If the ccs_wizard.cmd script doesn't work (command "mosml" not found) you will have to alter this file using Notepad to contain the full path to the Moscow ML executable.
		If commands like "draw" or "convert" aren't working, because "dot" cannot be found, you will have to insert the full path to the dot executable (to be found in the Graphviz directory) right at the start of the file "lts.sml", where it says
		
			(*  Enter dot path here: *)

			val dot = "dot";
			
		Paste your custom command instead of dot within the quotes.
		Then save the file.

2. *** How to use it ***


	To run ccs_wizard, just start ccs_wizard.sh (UNIX) or double-click on ccs_wizard.cmd (Windows).
	This will launch Moscow ML and initizialize it with the ccs_wizard bindings.
	
	To exit the program and close Moscow ML, use quit();
	More information on how to use Moscow ML and SML in general can be found on the web.
	Just one quick tip: The type unit contains () as its only value.
	
	Attention: When entering string data in Moscow ML, be aware that the character \ is to be entered as \\  !
	
	Once Moscow ML has been started, you can call the following procedures to do some CCS magic:


	CCS: The following procedures are to be used for conversions from string to expression and vice versa. They also handle bindings:

		lex : string -> token list
		
			Takes a CCS expression and breaks it into a list of tokens.
			A note on restriction sets: You have to use \ instead of \\ for the setminus to be recognized properly by Moscow ML.
			
		parse : token list -> bindings * exp
		
			Takes a sequence of tokens and converts it into a CCS syntax tree and a set of bindings.
			A binding of the identifier X to the expression e is denoted as X := e.
			To specify bindings, terminate your expressin with a semicolon (;) and then write down all your bindings. Commata (,) or semicola between bindings are optional and plain white space as binding separator will work as well.
			There will be no complaints if you don't define all the identifiers you are using, so be careful!
			
			The expression syntax is exactly the one defined in the NP lectures:
			
				P  ::=  0  |  X  |  a.P  |  P + P  |  P '|' P  | P \ H
			
			where a is an arbitrary action name (optionally having the active (!) or the passive (?) suffix) and H is a set of restricted action names.
			H is given in curly braces ({, }). If it contains an action name a without passive/active suffix, this is tread as meaning a, a! and a?. If it contains a !-suffixed action name, it must also contain the corresponding ?-suffixed name.
			The given alternatives for P are given in the order of strength with which they attract their constituents, so A + B | C is to be read as (A + B) | C.
			Internal actions (that cannot sync nor be restricted) must be enclosed in square brackets ([, ]). Including internal actions in H will cause an error.
		
		ccs : string -> bindings * exp
		
			Composition of lex and parse: Takes a string and converts it to an expression syntax tree and a set of bindings.
			See 'parse' for more information!
			Keep in mind that, ehen entering string data in Moscow ML, the character \ is to be entered as \\  !
		
		toString: exp -> string
		
			Kind of the inverse of 'ccs': Takes an expression (without bindings!) and converts to a minimally parenthesised string.
			
		matches : action -> action -> bool
		
			Decides if two action names match each other (for synchronisation).

		internal : action -> bool

			Decides if the given action is internal (which depends only on the action name being eclosed in square brackets).

		lookup : bindings -> string -> exp
		
			Takes a set of bindings and an identifier and looks up the definition for the identifier in the set.		
		
		load : string -> bindings * exp
		
			Loads the file identified by the given string and applies ccs to its entire content.
			Note that in order not to override the Moscow ML binding for 'load', load can only be referenced by 'CCS.load' !
			You may change this by declaring
			
				val load = CCS.load
				
			Paths given to this procedure have to be valid absolute or relative paths in the context of your particular operating system.
			Keep in mind that, ehen entering string data in Moscow ML, the character \ is to be entered as \\  !
				
	LTS: The following procedures are meant to treat an expression as a node in an Labeled Transition System (LTS):

		edges : bindings -> exp -> edge Set.set
		
			Takes a set of bindings and an expression and returns the set of edges that this expression has under these bindings in an LTS.
		
		setFormat : outputFormat -> unit
		getFormat : unit -> outputFormat
		
			Gets/sets the file format for LTS graphs. Available are SVG, PNG and PDF. Standard is SVG.
		
		setFileName : string -> unit
		getFileName : unit -> string
		
			Gets/sets the output file name for LTS graphs. Standard is "graphs/graph".
			Keep in mind that the file name is also suffixed with an index (to avoid overriding other files) and a file extension (*.dot and the extension corresponding to the selected output format).
		
		setDotCommand : string -> unit
		getDotCommand : unit -> string
		
			Gets/sets the command for calling the Graphviz tool "dot".
			In general you should not use setDotCommand. Instead you should try to change the command right at the start of the file "lts.sml", where it says
			
				(*  Enter dot path here: *)

				val dot = "dot";
				
			Paste your custom command instead of dot within the quotes.
			
		setOverwrite : bool -> unit
		getOverwrite : unit -> bool
		
			Gets/sets the flag for overwriting: If set to true, existent graph files may be overwritten by new graph files.
			Otherwise file names are appended an incremental numeric suffix to avoid overwriting.
			Default is false.
		
		draw : bindings * exp -> unit
		
			Takes a set of bindings and an expression, converts the resulting LTS to dot code and calls the "dot" tool on this code.
			The return values of parse and CCS.load make good argument values for this procedure!
			To get to know how the output files are namend and in what format the graph will be written, use getFileName and getDotCommand.
			
			By default, the graph is written to graphs/graph0.dot and then converted to an SVG file graphs/graph0.svg.
			This procedure avoids overwriting existing files by indexing them with a suffix, if this is requested. See 'setOverwrite'.
			
	Stepper: The following procedures give access to an interactive "stepper", that allows you to walk through an LTS:
			
		reset : bindings * exp -> unit
		
			Initializes the stepper with a set of bindings and a CCS expression.
			The return values of parse and CCS.load make good argument values for this procedure!
		
		current : unit -> bindings * exp

			Returns the set of bindings and the CCS expression the stepper is currently focused to.
		
		show  : unit -> unit

			Pretty-prints the currently focused expression, including all the relevant identifier bindings (if there are any).

		bindings : unit -> unit

			Pretty-prints the set of all the bindings the stepper knows of (if there are any).

		post  : unit -> unit

			Pretty-prints all the transitions possible from the currently focused expression.

		succ  : int -> unit

			Follows the n-th transition of the currently focused expression, which focuses the target of this transition.
			Transition numbers are listed by 'post'

		back  : unit -> unit

			Sets the stepper focus to the expression that has been focused last before the currently focused one.
			Multiple calls to this procedure may eventually bring the stepper back to the very first expression it focused after the last call to 'reset'.
		