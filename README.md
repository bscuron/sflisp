# Salesforce JSON Lisp Interpreter

```apex
// (* 2 3)
// Output: 6
System.debug(Interpreter.eval('["*", 2, 3]'));

// (* 1 2 3 4 5 6 7 8 9 10)
// Output: 3628800
System.debug(Interpreter.eval('["*", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]'));

// (/ 100 3)
// Output: 33
System.debug(Interpreter.eval('["/", 100, 3]]'));

// (/ 100 3.0)
// Output: 33.33...
System.debug(Interpreter.eval('["/", 100, 3.0]]'));

// (let ((firstName "John")
//       (lastName "Doe"))
//     (concat "Mr." " " firstName " " lastName))
// Output: "Mr. John Doe"
System.debug(Interpreter.eval('["let", [["firstName", "John"], ["lastName", "Doe"]], ["concat", "Mr.", " ", "$firstName", " ", "$lastName"]]'));

// (defun fac (n)
//     (if (<= n 1)
//         1
//         (* n (fac (- n 1)))))
// (fac 5)
// Output: 120
System.debug(Interpreter.eval('["progn", ["defun", "fac", ["n"], ["if", ["<=", "$n", 1], 1, ["*", "$n", ["fac", ["-", "$n", 1]]]]], ["fac", 5]]'));

// (and (= 1 1) (/= 1 2))
// Output: true
System.debug(Interpreter.eval('["and", ["=", 1, 1], ["/=", 1, 2]]'));

// (and)
// Output: true
System.debug(Interpreter.eval('["and"]'));

// (or)
// Output: false
System.debug(Interpreter.eval('["or"]'));

// (= "hello" "hello")
// Output: true
System.debug(Interpreter.eval('["=", "hello", "hello"]'));

// (/= "hello" "world")
// Output: true
System.debug(Interpreter.eval('["/=", "hello", "world"]'));

// (filter (lambda (x) (> x 1)) '(1 2 3))
// Output: '(2 3)
System.debug(Interpreter.eval('["filter", ["lambda", ["x"], [">", "$x", 1]], [1, 2, 3]]'));
System.debug(Interpreter.eval('["filter", [">", "$a", 1], [1, 2, 3]]'));

// (map (lambda (x) (concat "hello, " x "!")) '("world", "there"))
// Output: '("hello, world!", "hello, there!")
System.debug(Interpreter.eval('["map", ["concat", "hello, ", "$a", "!"], ["world", "there"]]'));

// (seq-reduce (lambda (a b) (* a b)) '(1 2 3 4 5) 1)
// Output: 120
System.debug(Interpreter.eval('["reduce", ["*", "$a", "$b"], [1, 2, 3, 4, 5], 1]'));

// (let ((mul (lambda (a b) (* a b))))
//     (seq-reduce 'mul [1, 2, 3, 4, 5] 1))
// Output: 120
System.debug(Interpreter.eval('["let", [["mul", ["lambda", ["a", "b"], ["*", "$a", "$b"]]]], ["reduce", "$mul", [1, 2, 3, 4, 5], 1]]'));

// (let ((a 1))
//     (let ((b a))
//         (+ a b)))
// Output: 2
System.debug(Interpreter.eval('["let", [["a", 1]], ["let", [["b", "$a"]], ["+", "$a", "$b"]]]'));

// (let ((a 1)
//       (b (+ a 1)))
//     b)
System.debug(Interpreter.eval('["let", [["a", 1], ["b", ["+", "$a", 1]]], "$b"]'));

// (defun foo () x)
// (let ((x 5))
//     (foo)))
// Output: Void-variable x
// System.debug(Interpreter.eval('["progn", ["defun", "foo", [], "$x"], ["let", [["x", 5]], ["foo"]]]'));

// (let ((x 5))
//     (defun foo () x)
//        (foo)))
// Output: 5
System.debug(Interpreter.eval('["let", [["x", 5]], ["defun", "foo", [], "$x"], ["foo"]]'));
```
