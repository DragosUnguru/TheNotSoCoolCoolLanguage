class List inherits MySuperClass {
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
                if manner = "descendent" then
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

