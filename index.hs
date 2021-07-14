-- Author: Isaias Carvalho --

--   Date = (Day, Month, Year)
type Date = (Integer, Integer, Integer)
type Person = String
type Book = (String, [String])
type Database = [(Person, Book, Date, Date)]

-- params: day to start count, quantity of days to count
findDayOfMonth :: Integer -> Integer -> Integer
findDayOfMonth startDay quantity
    |quantity == 0 = startDay
    |startDay == 30 = findDayOfMonth 1 quantity -1
    |otherwise = findDayOfMonth (startDay +1) (quantity -1)

-- params: start date, days to add
calculateDueDate :: Date -> Integer -> Date
calculateDueDate (day, month, year) borrowDays
    |day + borrowDays < 31 = (day + borrowDays, month, year)
    |day + borrowDays >= 31 && month +1 < 12 = (findDayOfMonth day borrowDays, month +1, year)
    |otherwise = (findDayOfMonth day borrowDays, month, year +1)

-- params: database, name to find borrowments
borrowedBooks :: Database -> Person -> [Book]
borrowedBooks [ ] _ = [ ]
borrowedBooks ((owner, (title, keys), borrowDate, dueDate) : resto) fulano
    |owner == fulano = (title, keys) : borrowedBooks resto fulano
    |otherwise = borrowedBooks resto fulano

-- params: database, book to find people that borrowed
peopleByBook :: Database -> String -> [Person]
peopleByBook [ ] _ = [ ]
peopleByBook ((person, (title, keys), borrowDate, dueDate): rest) book
    |title == book = person : peopleByBook rest book
    |otherwise = peopleByBook rest book

-- prams: database, name, book to borrow, borrow date, quantity of days to borrow
borrow :: Database -> Person -> Book -> Date -> Integer -> Database
borrow dBase pessoa  title todayDate qtdDays
    |qtdDays > 30 = error "Emprestimo maximo de 30 dias."
    |canBorrow dBase pessoa = (pessoa, title, todayDate, calculateDueDate todayDate qtdDays) : dBase
    |otherwise = error "Maximo de emprestimos alcançados"

-- params: database, person, book to return
returnBook :: Database -> Person -> Book -> Database
returnBook ((p, t, borrowDate, dueDate): r) f l
    |p == f && t == l = r
    |otherwise = (p,t, borrowDate, dueDate) : returnBook r f l
returnBook [ ] ful tit = error "Nao ha livro emprestado"

-- params: database, book name
checkAvailability :: Database -> String -> String
checkAvailability [ ] _ = "Livro disponivel para emprestimo."
checkAvailability ((owner, (title, keys), borrowDate, dueDate) : resto) livro
    |title == livro = "Livro encontra-se emprestado atualmente."
    |otherwise = checkAvailability resto livro

-- params: database, name
canBorrow :: Database -> Person -> Bool
canBorrow database person
    |length(borrowedBooks database person) >= 3 = False
    |otherwise = True

-- params: array of values, value to check if is present
includes :: [String] -> String -> Bool 
includes [ ] _ = False 
includes (actual: rest) search
    |actual == search = True
    |otherwise = includes rest search

-- params: array of books keywords, array for comparison
matchKeywords :: [String] -> [String] -> Bool
matchKeywords _ [ ] = False 
matchKeywords keywords (key: rest)
    |includes keywords key = True
    |otherwise = matchKeywords keywords rest

-- params: database, keywords to find
searchByKeys :: Database -> [String] -> [Book]
searchByKeys [] _ = [ ]
searchByKeys ((owner, (title, keywords), borrowDate, dueDate): rest) searchKeys
    |matchKeywords keywords searchKeys = (title, keywords) : searchByKeys rest searchKeys
    |otherwise = searchByKeys rest searchKeys

-- d1 reference date, d2 date to compare
dateIsBefore :: Date -> Date -> Bool
dateIsBefore (d1, m1, y1) (d2, m2, y2)
    |y1 == y2 && m1 == m2 && d2 == d1 = False
    |y1 == y2 && m1 == m2 && d2 >= d1 = False
    |y1 == y2 && m1 < m2 = False
    |y1 > y2 = False
    |otherwise = True

-- Params: Database, Todays date
checkDueBorrowments :: Database -> Date -> Database
checkDueBorrowments [] _ = [ ]
checkDueBorrowments ((owner, (title, keywords), borrowDate, dueDate): rest) todayDate
    |dateIsBefore todayDate dueDate = (owner, (title, keywords), borrowDate, dueDate) : checkDueBorrowments rest todayDate
    |otherwise = checkDueBorrowments rest todayDate

-- Formato Banco: (Dono, (TituloBook, [Keywords]), Data de Emprestimo, Data de Vencimento)
teste = [
    ("Paulo", ("A Mente Nova do Rei", ["Ficcao", "Magia"]), (13, 7, 2021), (28, 7, 2021)), 
    ("Ana", ("O Segredo de Luiza", ["Ficcao", "Romance"]), (13, 7, 2021), (28, 7, 2021)),
    ("Paulo", ("O Pequeno Principe", ["Ficcao", "Infantil"]), (13, 7, 2021), (28, 7, 2021)), 
    ("Mauro", ("O Capital", ["Filosofia"]), (13, 7, 2021), (28, 7, 2021)),
    ("Francisco", ("O Auto da Compadecida", ["Comedia", "Religioso"]), (13, 7, 2021), (28, 7, 2021)),
    ("Paulo", ("Interestelar", ["Ficcao", "Cientifico"]), (13, 7, 2021), (30, 7, 2021)),
    ("Tati", ("Waterloo", ["Historia", "Guerra"]), (13, 7, 2021), (28, 11, 2021))]

-- EXAMPLES
-- to borrow a book
--     borrow teste "Jhon" ("Neuromancer", ["Sci-fi", "Tech", "Future"]) (14, 7, 2021) 20

-- to return a book
--     returnBook teste "Jhon" ("Neuromancer", ["Sci-fi", "Tech", "Future"])

-- to find all books borrowed by a person
--     borrowedBooks teste "Jhon"

-- to find all people that borrowed a book
--     peopleByBook teste "Neuromancer"

-- to check if a book is borrowed
--     checkAvailability teste "Neuromancer"

-- to search books with keywords
--     searchByKeys teste ["Sci-fi", "Tech"]

-- to check if there are some due borroments
--     checkDueBorrowments teste (30, 7, 2021)