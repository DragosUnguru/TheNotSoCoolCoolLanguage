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
