# borrowbooks
A fake and simple library manager in haskell

## How to use
You must have `Haskell` installed in your system.<br>
Once you have cloned the repo, cd into the folder:
```
cd borrowbooks
```

In order to test this in a better way, I recommend the interactive mode:
```
gchi
```

When you are inside Prelude, you can load the `.hs` file, like this:
```
:load index.hs
```

And now you can go ahead to examples.

## Examples
#### borrow a book
```
borrow teste "Jhon" ("Neuromancer", ["Sci-fi", "Tech", "Future"]) (14, 7, 2021) 20
```

#### return a book
```
returnBook teste "Jhon" ("Neuromancer", ["Sci-fi", "Tech", "Future"])
```

#### find all books borrowed by a person
```
borrowedBooks teste "Jhon"
```

#### find all people that borrowed a book
```
peopleByBook teste "Neuromancer"
```

#### check if a book is borrowed
```
checkAvailability teste "Neuromancer"
```

#### search books with keywords
```
searchByKeys teste ["Sci-fi", "Tech"]
```

#### check if there are some due borroments
```
checkDueBorrowments teste (30, 7, 2021)
```
