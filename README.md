# Lisp Interpreter in Salesforce Apex

```apex
LispInterpreter i = new LispInterpreter();

System.debug(i.eval('(+)'));                                                                      // 0
System.debug(i.eval('(*)'));                                                                      // 1
System.debug(i.eval('(-)'));                                                                      // 0
//System.debug(i.eval('(/)'));                                                                    // Error: wrong number of arguments

System.debug(i.eval('(+ 2)'));                                                                    // 2
System.debug(i.eval('(* 2)'));                                                                    // 2
System.debug(i.eval('(- 2)'));                                                                    // -2
System.debug(i.eval('(/ 2)'));                                                                    // 0.5

System.debug(i.eval('(+ 2 3)'));                                                                  // 5
System.debug(i.eval('(* 2 3)'));                                                                  // 6
System.debug(i.eval('(- 2 3)'));                                                                  // -1
System.debug(i.eval('(/ 2 3)'));                                                                  // 0.67

System.debug(i.eval('(if () 1 0)'));                                                              // 0
System.debug(i.eval('(if () 1 0 -1)'));                                                           // -1
System.debug(i.eval('(if nil 1 0)'));                                                             // 0
System.debug(i.eval('(if nil 1 0 -1)'));                                                          // -1
System.debug(i.eval('(if t 1 0 -1)'));                                                            // 1
System.debug(i.eval('(if 5 1 0 -1)'));                                                            // 1
System.debug(i.eval('(if \'hi 1 0 -1)'));                                                         // 1

System.debug(i.eval('(and)'));                                                                    // t
System.debug(i.eval('(and 1 2 3)'));                                                              // 3
System.debug(i.eval('(and nil 2 3)'));                                                            // nil
System.debug(i.eval('(and nil () nil)'));                                                         // nil

System.debug(i.eval('(or)'));                                                                     // nil
System.debug(i.eval('(or nil nil 5)'));                                                           // 5
System.debug(i.eval('(or () nil)'));                                                              // nil
System.debug(i.eval('(or 0 1 2)'));                                                               // 0

System.debug(i.eval('(not nil)'));                                                                // t
System.debug(i.eval('(not 0)'));                                                                  // nil
System.debug(i.eval('(not (not nil))'));                                                          // nil
System.debug(i.eval('(not ())'));                                                                 // t

System.debug(i.eval('(quote x)'));                                                                // x
System.debug(i.eval('(quote (1 2 3))'));                                                          // (1 2 3)
System.debug(i.eval('(quote nil)'));                                                              // nil
System.debug(i.eval('\'x'));                                                                      // x
System.debug(i.eval('\'(1 2 3)'));                                                                // (1 2 3)
System.debug(i.eval('\'nil'));                                                                    // nil

System.debug(i.eval('\'(1 . 2)'));                                                                // (1 . 2)

System.debug(i.eval('(cons 1 2)'));                                                               // (1 . 2)
System.debug(i.eval('(car (cons 1 2))'));                                                         // 1
System.debug(i.eval('(cdr (cons 1 2))'));                                                         // 2
System.debug(i.eval('(cons 1 (cons 2 3))'));                                                      // (1 2 . 3)

System.debug(i.eval('(cond (nil \'no) (t \'yes))'));                                              // yes
System.debug(i.eval('(cond (t \'no) (nil \'yes))'));                                              // no

System.debug(i.eval('((lambda (x y) (* x y)) 2 3)'));                                             // 6

System.debug(i.eval('(let ())'));                                                                 // nil
System.debug(i.eval('(let ((a 25) (b 4)) (* a b))'));                                             // 100
//System.debug(i.eval('(let ((a 25) (b (* a 2))) (* a b))'));                                     // Error: unbound symbol a
System.debug(i.eval('(let* ((a 25) (b (* a 2))) (* a b))'));                                      // 1250

System.debug(i.eval('(= 1)'));                                                                    // t
System.debug(i.eval('(= 1 (/ 9 9))'));                                                            // t
System.debug(i.eval('(= 1 2)'));                                                                  // nil
System.debug(i.eval('(eq 1 1)'));                                                                 // nil
System.debug(i.eval('(eql 1 1)'));                                                                // t
System.debug(i.eval('(equal 1 1)'));                                                              // t
System.debug(i.eval('(< 1 2 3)'));                                                                // t
System.debug(i.eval('(> 1 2 3)'));                                                                // nil
System.debug(i.eval('(<= 0 -1 -2)'));                                                             // nil
System.debug(i.eval('(>= 0 1 2)'));                                                               // nil
System.debug(i.eval('(/= 1 2)'));                                                                 // t
System.debug(i.eval('(/= 1 1)'));                                                                 // nil

System.debug(i.eval('(apply * 1 2 \'(3 4 5))'));                                                  // 120
System.debug(i.eval('(defun fac (n) (if (<= n 1) 1 (* n (fac (- n 1))))) (fac 5)'));              // 120
System.debug(i.eval('(defun fac (n) (cond ((<= n 1) 1) (t (* n (fac (- n 1)))))) (fac 5)'));      // 120

System.debug(i.eval('(assoc \'b \'((a . 1) (b . 2) (c . 3)))'));                                  // (b . 2)
System.debug(i.eval('(rassoc 2 \'((a . 1) (b . 2) (c . 3)))'));                                   // (b . 2)
System.debug(i.eval('(rassoc (+ 1 1) \'((a . 1) (b . 2) (c . 3)))'));                             // (b . 2)
System.debug(i.eval('(or (assoc \'z \'((a . 1) (b . 2) (c . 3))) (* 9 2))'));                     // 18

System.debug(i.eval('(iota 10)'));                                                                // (0 1 2 3 4 5 6 7 8 9)
System.debug(i.eval('(iota 20 10 -1)'));                                                          // (10 9 8 7 6 5 4 3 2 1 0 -1 -2 -3 -4 -5 -6 -7 -8 -9)
System.debug(i.eval('(iota 10 1 0)'));                                                            // (1 1 1 1 1 1 1 1 1 1)
System.debug(i.eval('(apply \'* (iota 5 1))'));                                                   // 120

System.debug(i.eval('(append)'));                                                                 // nil
System.debug(i.eval('(append \'(1 2 3) \'(4 5 6))'));                                             // (1 2 3 4 5 6)

System.debug(i.eval('(null nil)'));                                                               // t
System.debug(i.eval('(null \'())'));                                                              // t
System.debug(i.eval('(null 1)'));                                                                 // nil

System.debug(i.eval('(map (lambda (x) (* x 100)) (iota 10 1))'));                                 // (100 200 300 400 500 600 700 800 900 1000)
System.debug(i.eval('(filter (lambda (x) (> x 500)) (map (lambda (x) (* x 100)) (iota 10 1)))')); // (600 700 800 900 1000)

System.debug(i.eval('(join \'(1 2 3) ",")'));                                                     // 1,2,3

System.debug(i.eval('(reverse (iota 10))'));                                                      // (9 8 7 6 5 4 3 2 1 0)
```