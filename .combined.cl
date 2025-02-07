(*
   The class A2I provides integer-to-string and string-to-integer
conversion routines.  To use these routines, either inherit them
in the class where needed, have a dummy variable bound to
something of type A2I, or simpl write (new A2I).method(argument).
*)


(*
   c2i   Converts a 1-character string to an integer.  Aborts
         if the string is not "0" through "9"
*)
class A2I {

     c2i(char : String) : Int {
	if char = "0" then 0 else
	if char = "1" then 1 else
	if char = "2" then 2 else
        if char = "3" then 3 else
        if char = "4" then 4 else
        if char = "5" then 5 else
        if char = "6" then 6 else
        if char = "7" then 7 else
        if char = "8" then 8 else
        if char = "9" then 9 else
        { abort(); 0; }  -- the 0 is needed to satisfy the typchecker
        fi fi fi fi fi fi fi fi fi fi
     };

(*
   i2c is the inverse of c2i.
*)
     i2c(i : Int) : String {
	if i = 0 then "0" else
	if i = 1 then "1" else
	if i = 2 then "2" else
	if i = 3 then "3" else
	if i = 4 then "4" else
	if i = 5 then "5" else
	if i = 6 then "6" else
	if i = 7 then "7" else
	if i = 8 then "8" else
	if i = 9 then "9" else
	{ abort(); ""; }  -- the "" is needed to satisfy the typchecker
        fi fi fi fi fi fi fi fi fi fi
     };

(*
   a2i converts an ASCII string into an integer.  The empty string
is converted to 0.  Signed and unsigned strings are handled.  The
method aborts if the string does not represent an integer.  Very
long strings of digits produce strange answers because of arithmetic 
overflow.

*)
     a2i(s : String) : Int {
        if s.length() = 0 then 0 else
	if s.substr(0,1) = "-" then ~a2i_aux(s.substr(1,s.length()-1)) else
        if s.substr(0,1) = "+" then a2i_aux(s.substr(1,s.length()-1)) else
           a2i_aux(s)
        fi fi fi
     };

(*
  a2i_aux converts the usigned portion of the string.  As a programming
example, this method is written iteratively.
*)
     a2i_aux(s : String) : Int {
	(let int : Int <- 0 in	
           {	
               (let j : Int <- s.length() in
	          (let i : Int <- 0 in
		    while i < j loop
			{
			    int <- int * 10 + c2i(s.substr(i,1));
			    i <- i + 1;
			}
		    pool
		  )
	       );
              int;
	    }
        )
     };

(*
    i2a converts an integer to a string.  Positive and negative 
numbers are handled correctly.  
*)
    i2a(i : Int) : String {
	if i = 0 then "0" else 
        if 0 < i then i2a_aux(i) else
          "-".concat(i2a_aux(i * ~1)) 
        fi fi
    };
	
(*
    i2a_aux is an example using recursion.
*)		
    i2a_aux(i : Int) : String {
        if i = 0 then "" else 
	    (let next : Int <- i / 10 in
		i2a_aux(next).concat(i2c(i - next * 10))
	    )
        fi
    };

};-- Interface
class Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {{ abort(); true; }};
};

class PriceComparator inherits Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj1 of
                dummy1 : Product =>
                    case obj2 of
                        dummy2 : Product => if dummy1.getprice() < dummy2.getprice() then result <- true else result <- false fi;
                        any_other2 : MySuperClass => abort();
                    esac;
                any_other1 : MySuperClass => abort();
            esac;

            result;
        }
    };
};

class RankComparator inherits Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj1 of
                dummy1 : Rank =>
                    case obj2 of
                        dummy2 : Rank => if dummy1.getRankHierarchy() < dummy2.getRankHierarchy() then result <- true else result <- false fi;
                        any_other2 : MySuperClass => abort();
                    esac;
                any_other1 : MySuperClass => abort();
            esac;

            result;
        }
    };
};

class AlphabeticComparator inherits Comparator {
    compare(obj1 : MySuperClass, obj2 : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj1 of
                dummy1 : StringWrapper =>
                    case obj2 of
                        dummy2 : StringWrapper => if dummy1.getString() < dummy2.getString() then result <- true else result <- false fi;
                        any_other2 : MySuperClass => abort();
                    esac;
                any_other1 : MySuperClass => abort();
            esac;

            result;
        }
    };
};
-- Interface
class Filter {
    apply(obj : MySuperClass) : Bool {{ abort(); true; }};
};

class ProductFilter inherits Filter {
    apply(obj : MySuperClass) : Bool {
        {
            case obj of 
                product : Product => true;
                --No need to check for every other type individually.
                any_other : MySuperClass => false;
            esac;
        }
    };
};

class RankFilter inherits Filter {
    apply(obj : MySuperClass) : Bool {
        {
            case obj of
                rank : Rank => true;
                --No need to check for every other type individually.
                any_other : MySuperClass => false;
            esac;
        }
    };
};

class SamePriceFilter inherits Filter {
    apply(obj : MySuperClass) : Bool {
        let result : Bool
        in {
            case obj of 
                product : Product => result <- product.getprice() = new Product.init("", "", product.price()).getprice();
                any_other : MySuperClass => false;
            esac;

            result;
        }
    };
};class List inherits MySuperClass {
    isEmpty() : Bool { true };

    hd() : MySuperClass { { abort(); new MySuperClass; } };

    tl() : List { { abort(); self; } };

    getSize() : Int { 0 };

    getNth(n : Int) : MySuperClass { { abort(); new MySuperClass; } };

    add(h : MySuperClass): List {
        (new Cons).init(h, self)
    };

    cons(h : MySuperClass) : Cons {
        new Cons.init(h, self)
    };

    print() : IO { out_string("\n") };

    reverse() : List { self };

    append(l : List) : List { l };

    removeNth(idx : Int) : List { { abort(); self; } };

    toString() : String { "[  ]\n" };

    filter(f : Filter) : List { self };

    getMin(comparator : Comparator) : MySuperClass { { abort(); new MySuperClass; } };

    getMax(comparator : Comparator) : MySuperClass { { abort(); new MySuperClass; } };

    removeValue(value : MySuperClass) : List { self };

    sort(c : Comparator, manner : String) : List { self };
};

class Cons inherits List {
    hd : MySuperClass;
    tl : List;

    init(h : MySuperClass, t : List) : Cons {
        {
            hd <- h;
            tl <- t;
            self;
        }
    };

    -- Supradefinirea funcțiilor din clasa List
    isEmpty() : Bool { false };

    hd() : MySuperClass { hd };

    tl() : List { tl };

    getSize() : Int {
        let count : Int <- 0,
            copy : List <- self

        in {
            while (not copy.isEmpty()) loop {
                count <- count + 1;
                copy <- copy.tl();
            } pool;
            count;
        }
    };

    (*
        Gets the Nth element from list, in a 0-indexed logic
    *)
    getNth(n : Int) : MySuperClass {
        let idx : Int <- 0,
            copy : List <- self
        
        in {
            -- Check if it is a valid index
            if copy.getSize() <= n then
                abort()
            else if n < 0 then
                abort()
            else {
                while (idx < n) loop {
                    copy <- copy.tl();
                    idx <- idx + 1;
                } pool;
            } fi fi;

            copy.hd();
        }
    };

    print() : IO {
        {
            out_string(hd.toString());
            out_string(" ");

            tl.print();
        }
    };

    removeNth(idx : Int) : List {
        let ptr : Int <- 0,
            copy : List <- self,
            acc : List <- new List
        in {
            -- Check if index is valid
            if self.getSize() <= idx then
                abort()
            else if idx < 0 then
                abort()
            else {
                -- Valid index, remove element
                while (not copy.isEmpty()) loop {
                    if not idx = ptr then {
                        acc <- acc.add(copy.hd());
                    } else 0 fi;

                    ptr <- ptr + 1;
                    copy <- copy.tl();
                } pool;
            } fi fi;

            acc;
        }
    };

    add(o : MySuperClass): List {
        (new Cons).init(hd, tl.add(o))
    };

    append(l : List) : List {
        let copy : List <- self,
            reversedCopy : List <- copy.reverse()

        in {
            while (not l.isEmpty()) loop {
                reversedCopy <- reversedCopy.cons(l.hd());
                l <- l.tl();
            } pool;

            reversedCopy.reverse();
        }
    };

    reverse() : List {
        let copy : List <- self,
            acc : List <- new List

        in {
            while (not copy.isEmpty()) loop {
                acc <- acc.cons(copy.hd());
                copy <- copy.tl();
            } pool;

            acc;
        }
    };

    (*
        toString() method used to print when the list is a instance
        of a list of lists. Therefore, this method will be used to print
        our list of lists and, with the help of dynamic dispatch, will also
        print all the objects of the inner lists as this calls toString() itself
    *)
    toString() : String {
        let idx : Int <- 1,
            copy : List <- self,
            acc : String <- new String.concat("[ ")

        in {
            while (not copy.isEmpty()) loop {
                acc <- acc.concat(copy.hd().toString()).concat(", ");
                copy <- copy.tl();
            } pool;
            
            -- Trim the last semicolon separator and close the bracket
            acc <- acc.substr(0, acc.length() - 2).concat(" ]\n");
        }
    };

    filter(f : Filter) : List {
        let ftl : List <- tl.filter(f)
        in if f.apply(hd) then ftl.cons(hd) else ftl fi
    };

    getMax(comparator : Comparator) : MySuperClass {
        let max : MySuperClass <- self.hd(),
            copy : List <- self
        in {
            while (not copy.isEmpty()) loop {
                if comparator.compare(max, copy.hd()) then max <- copy.hd()
                else 0 fi;

                copy <- copy.tl();
            } pool;

            max;
        }
    };

    getMin(comparator : Comparator) : MySuperClass {
        let min : MySuperClass <- self.hd(),
            copy : List <- self
        in {
            while (not copy.isEmpty()) loop {
                if not comparator.compare(min, copy.hd()) then
                    min <- copy.hd()
                else 0 fi;

                copy <- copy.tl();
            } pool;

            min;
        }
    };

    removeValue(value : MySuperClass) : List {
        let copy : List <- self,
            result : List <- new List

        in {
            while (not copy.isEmpty()) loop {
                if (not value = copy.hd()) then
                    result <- result.add(copy.hd())
                else 0 fi;

                copy <- copy.tl();
            } pool;

            result;
        }
    };

    sort(comparator : Comparator, manner : String) : List {
        let copy : List <- self,
            result : List <- new List,
            next : MySuperClass
        in {
            while (not copy.isEmpty()) loop {
                if manner = "descending" then
                    next <- copy.getMax(comparator)
                else
                    next <- copy.getMin(comparator)
                fi;

                result <- result.add(next);
                copy <- copy.removeValue(next);
            } pool;

            result;
        }
    };
};

class Main inherits IO {
    lists : List <- new List;
    looping : Bool <- true;

    (*
        The method is based on a 1-indexed manner. Parameter
        'idx' should be provided in such manner
    *)
    printNthList(idx : Int) : IO {
        out_string(lists.getNth(idx - 1).toString())
    };

    dump() : IO {
        let idx : Int <- 1,
            size : Int <- lists.getSize(),
            acc : IO <- new IO

        in {
            while (idx <= size) loop {
                out_int(idx);
                out_string(": ");
                acc <- printNthList(idx);
                idx <- idx + 1;
            } pool;

            -- Just to satisfy the Type-Check
            acc;
        }
    };

    merge(idx1 : Int, idx2 : Int) : List {
        let copy : List <- lists,
            second_idx : Int <- idx2,
            newEntry : List
        in {

            (*
                This block strongly-types the <append> method to lists, rather than any other
                interface object. This way we dont have to define a method for every other sub-class
                of out interface
            *)
            case copy.getNth(idx1 - 1) of 
                list1 : List =>
                    case copy.getNth(idx2 - 1) of
                        list2 : List => newEntry <- list1.append(list2); 
                    esac;
            esac;

            copy <- copy.removeNth(idx1 - 1);

            -- Manage the new index, if needed
            if idx1 < idx2 then idx2 <- idx2 - 2 else idx2 <- idx2 - 1 fi;
            copy <- copy.removeNth(idx2);

            copy <- copy.add(newEntry);
            copy;
        }
    };

    (*
        Get Nth list from our list of lists by enforcing List type
        on elements
    *)
    getNthList(idx : Int) : List {
        let copy : List <- lists
        in {
            case copy.getNth(idx - 1) of
                result : List => result;
            esac;
        }
    };

    replaceListAtIndex(new_list : List, idx : Int) : List {
        let new_instance : List <- new List,
            copy : List <- lists,
            ptr : Int <- 1

        in {
            while (not copy.isEmpty()) loop {
                if (ptr = idx) then
                    new_instance <- new_instance.add(new_list)
                else
                    new_instance <- new_instance.add(copy.hd())
                fi;

                ptr <- ptr + 1;
                copy <- copy.tl();
            } pool;

            lists <- new_instance;
            new_instance;
        }
    };

    main() : Object {
        --Start program with "load" command
        let cmd_tokenizer : Tokenizer <- new Tokenizer,
            command : String <- "load",
            a2i : A2I <- new A2I
        in {
            while looping loop {

                if command = "load" then {
                    -- LOAD COMMAND

                    let tokenizer : Tokenizer <- new Tokenizer.init(in_string()),
                        type : String <- tokenizer.getFirstToken(),
                        new_list : List <- new List
                    in {
                        while (not type = "END") loop {
                            -- Parse incoming object
                            if type = "Officer" then new_list <- new_list.add(new Officer.init(tokenizer.getSecondToken()))
                            else if type = "Sergent" then new_list <- new_list.add(new Sergent.init(tokenizer.getSecondToken()))
                            else if type = "Corporal" then new_list <- new_list.add(new Corporal.init(tokenizer.getSecondToken()))
                            else if type = "Private" then new_list <- new_list.add(new Private.init(tokenizer.getSecondToken()))
                            else if type = "Soda" then new_list <- new_list.add(new Soda.init(tokenizer.getSecondToken(), tokenizer.getThirdToken(), a2i.a2i(tokenizer.getFourthToken())))
                            else if type = "Coffee" then new_list <- new_list.add(new Coffee.init(tokenizer.getSecondToken(), tokenizer.getThirdToken(), a2i.a2i(tokenizer.getFourthToken())))
                            else if type = "Laptop" then new_list <- new_list.add(new Laptop.init(tokenizer.getSecondToken(), tokenizer.getThirdToken(), a2i.a2i(tokenizer.getFourthToken())))
                            else if type = "Router" then new_list <- new_list.add(new Router.init(tokenizer.getSecondToken(), tokenizer.getThirdToken(), a2i.a2i(tokenizer.getFourthToken())))
                            else if type = "String" then new_list <- new_list.add(new StringWrapper.init(tokenizer.getSecondToken()))
                            else if type = "Bool" then new_list <- new_list.add(new BooleanWrapper.init(tokenizer.getSecondToken()))
                            else if type = "String" then new_list <- new_list.add(new StringWrapper.init(tokenizer.getSecondToken()))
                            else if type = "Int" then new_list <- new_list.add(new IntWrapper.init(a2i.a2i(tokenizer.getSecondToken())))
                            else if type = "IO" then new_list <- new_list.add(new IOWrapper.init())
                            else abort()
                            fi fi fi fi fi fi fi fi fi fi fi fi fi;

                            -- Parse next input line containing the object for the current list
                            tokenizer <- tokenizer.init(in_string());
                            type <- tokenizer.getFirstToken();
                        } pool;

                        -- Insert the list of objects to our list of lists
                        lists <- lists.add(new_list);
                    };
                }
                else if command = "print" then {
                    -- PRINT COMMAND

                    if 2 < cmd_tokenizer.getTokens().getSize() then
                        -- Invalid command
                        abort()
                    else if cmd_tokenizer.getTokens().getSize() = 1 then
                        --No index provided, print whole list
                        dump()
                    else
                        -- Print list at given index
                        printNthList(a2i.a2i(cmd_tokenizer.getSecondToken()))
                    fi fi;
                }
                else if command = "merge" then {
                    -- MERGE COMMAND

                    if not cmd_tokenizer.getTokens().getSize() = 3 then
                        abort()
                    else
                        lists <- merge(a2i.a2i(cmd_tokenizer.getSecondToken()), a2i.a2i(cmd_tokenizer.getThirdToken()))
                    fi;
                }
                else if command = "filterBy" then {
                    -- FILTERBY COMMAND
                    if not cmd_tokenizer.getTokens().getSize() = 3 then
                        abort()
                    else {
                        let idx : Int <- a2i.a2i(cmd_tokenizer.getSecondToken()),
                            new_list : List <- getNthList(idx),
                            filter_name : String <- cmd_tokenizer.getThirdToken(),
                            chosen_filter : Filter
                        in {
                            -- Parse filter
                            if filter_name = "ProductFilter" then chosen_filter <- new ProductFilter
                            else if filter_name = "RankFilter" then chosen_filter <- new RankFilter
                            else if filter_name = "SamePriceFilter" then chosen_filter <- new SamePriceFilter
                            else abort()
                            fi fi fi;

                            -- Apply filter and replace list at index
                            new_list <- new_list.filter(chosen_filter);
                            lists <- replaceListAtIndex(new_list, idx);
                        };
                    } fi;
                }
                else if command = "sortBy" then {
                    -- SORTBY COMMAND
                    if not cmd_tokenizer.getTokens().getSize() = 4 then
                        abort()
                    else {
                        let idx : Int <- a2i.a2i(cmd_tokenizer.getSecondToken()),
                            new_list : List <- getNthList(idx),
                            comparator_name : String <- cmd_tokenizer.getThirdToken(),
                            sorting_manner : String <- cmd_tokenizer.getFourthToken(),
                            chosen_comparator : Comparator
                        in {
                            -- Parse comparator
                            if comparator_name = "PriceComparator" then chosen_comparator <- new PriceComparator
                            else if comparator_name = "RankComparator" then chosen_comparator <- new RankComparator
                            else if comparator_name = "AlphabeticComparator" then chosen_comparator <- new AlphabeticComparator
                            else abort()
                            fi fi fi;

                            -- Apply filter and replace list at index
                            new_list <- new_list.sort(chosen_comparator, sorting_manner);
                            lists <- replaceListAtIndex(new_list, idx);
                        };
                    } fi;
                }
                else abort()
                fi fi fi fi fi;

                -- Continue parsing commands
                cmd_tokenizer <- cmd_tokenizer.init(in_string());
                command <- cmd_tokenizer.getFirstToken();
            } pool;
        }
    };
};
(*******************************
 *** Classes Product-related ***
 *******************************)

class MySuperClass inherits IO {
    toString() : String {
        {
            abort(); "";
        }
    };

    getString() : String { { abort(); new String; } };
};

class Product inherits MySuperClass {
    name : String;
    model : String;
    price : Int;

    init(n : String, m: String, p : Int) : SELF_TYPE {{
        name <- n;
        model <- m;
        price <- p;
        self;
    }};

    price() : Int { price };

    getprice() : Int{ price * 119 / 100 };

    toString() : String {
        type_name().concat("(").concat(name).concat(";").concat(model).concat(")")
    };
};

class Edible inherits Product {
    -- VAT tax is lower for foods
    getprice():Int { price * 109 / 100 };
};

class Soda inherits Edible {
    -- sugar tax is 20 bani
    getprice():Int {price * 109 / 100 + 20};
};

class Coffee inherits Edible {
    -- this is technically poison for ants
    getprice():Int {price * 119 / 100};
};

class Laptop inherits Product {
    -- operating system cost included
    getprice():Int {price * 119 / 100 + 499};
};

class Router inherits Product {};

(****************************
 *** Classes Rank-related ***
 ****************************)
class Rank inherits MySuperClass {
    name : String;

    init(n : String) : SELF_TYPE {{
        name <- n;
        self;
    }};

    toString() : String {
        type_name().concat("(").concat(name).concat(")")
    };

    getRankHierarchy() : Int {{ abort(); 0; }};
};

class Private inherits Rank {
    getRankHierarchy() : Int {
        4
    };
};

class Corporal inherits Private {
    getRankHierarchy() : Int {
        3
    };
};

class Sergent inherits Corporal {
    getRankHierarchy() : Int {
        2
    };
};

class Officer inherits Sergent {
    getRankHierarchy() : Int {
        1
    };
};

class Tokenizer {
    line : String;
    delimiter : String <- " ";
    tokens : List;

    -- Initialize Tokenizer
    init(ln : String) : Tokenizer {
        let token_start : Int <- 0,
            token_end : Int <- 0,
            acc_tokens : List <- new List

        -- Tokenize and construct the <tokens> list
        in {
            line <- ln;

            while token_end < ln.length() loop {
                if ln.substr(token_end, 1) = delimiter then {
                    acc_tokens <- acc_tokens.add(new StringWrapper.init(ln.substr(token_start, token_end - token_start)));
                    token_start <- token_end + 1;
                } else 0 fi;
                token_end <- token_end + 1;
            } pool;

            -- Add last token, when the delimiter is '\n'
            tokens <- acc_tokens.add(new StringWrapper.init(ln.substr(token_start, token_end - token_start)));
            self;
        }
    };

    getTokens() : List {
        tokens
    };

    getFirstToken() : String {
        tokens.hd().getString()
    };

    getSecondToken() : String {
        tokens.tl().hd().getString()
    };

    getThirdToken() : String {
        tokens.tl().tl().hd().getString()
    };

    getFourthToken() : String {
        tokens.tl().tl().tl().hd().getString()
    };
};class StringWrapper inherits MySuperClass {
    string : String;

    init(str : String) : SELF_TYPE {
        {
            string <- str;
            self;
        }
    };

    toString() : String {
        "String".concat("(").concat(string).concat(")")
    };

    getString() : String {
        string
    };

    concat(str : String) : SELF_TYPE {
        {
            string.concat(str);
            self;
        }
    };
};

class IntWrapper inherits MySuperClass {
    number : Int;

    init(integer : Int) : SELF_TYPE {
        {
            number <- integer;
            self;
        }
    };

    toString() : String {
        "Int".concat("(").concat(new A2I.i2a(number)).concat(")")
    };
};

class IOWrapper inherits MySuperClass {
    
    init() : SELF_TYPE { self };

    toString() : String {
        "IO()"
    };
};

class BooleanWrapper inherits MySuperClass {
    instance : Bool;

    init(boolean : String) : SELF_TYPE {
        {
            if boolean = "true" then instance <- true else instance <- false fi;
            self;
        }
    };

    toString() : String {
        if instance = true then "Bool(true)" else "Bool(false)" fi
    };
};
