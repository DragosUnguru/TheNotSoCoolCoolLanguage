            # Unguru Dragos-Gabriel, 343C1

                #   HOMEWORK 0 - COOL


    # THE IDEEA BEHIND

    My approach at implementing an abstract list that can contain
every single type and to be as easy to extend as possible stands in
the ideea of an abstract "interface" that can be inherited.

    Every object defined by the homework's text (Privates, Products, Coffees, etc),
ultimately inherits an abstract class, <MySuperClass> (that inherits Object class).

    This makes the extendability of the program as easy as:
        Step 1: Declare your new class and inherit "MySuperClass" (overriding the
                toString() method as you please).
        Step 2: In main, insert 1 line telling how to initiate your new class.
    Done, as simple as that!

    This approach also permits the easy use and printing of the <lists of lists> structure,
as it dynamically dispatches every list to every element of the said list by a simple .toString() call.


    # FILTERS, COMPARATORS, AND MORE

    Using this approach, we can differentiate each object
very easily (as seen in the said interfaces).

    For the comparison of Ranks, I've defined a method that returs
a number that puts all of them in a hierarchy. This is used in the
comparator class.

    To support even COOL's defined data types, I've created a wrapper
class for each one (there are only 4 types) that is implemented in the
exact same manner as implementing any other class is done: create the class
and override the <toString()> method.
    This seems like the most elegant approach, as every OOP languages do this
for various classes.