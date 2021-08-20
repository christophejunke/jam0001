(defpackage :fcc-lang
  ;; More Of A Comment
  (:nicknames :moac)
  (:use :cl)
  (:documentation "first-class comments language"))

(in-package :fcc-lang)

;; ROUGH SPEC

;; a comment associates meta-data to a value (including code)

;; comments are values that can be manipulated by the program

;; a literal comment is text that is attached to a file or to the next
;; expressions if it exists; at runtime a comment can be attached to
;; any value, as long as the value lives

;; there are diffent types of comments (plain text, javadoc, etc.?)

;; A comment that starts with ":" or "!" is associated to the runtime
;; value of the expression/statement it annotate (otherwise, it is a
;; code comment)

;; Comments evaluate to nothing. Some comments can produce
;; side-effects (logging, debugging notes, ...); they are "effectful
;; comments"; other are "silent comments"

;; A comment that starts with "!" is effectful.

;; It is possible to list all the comments associated with a value
;; It is possible to comment a comment
;; It is possible to edit or remove a comment

;; literal effectful comments have access to the lexical scope (and
;; dynamic environment), and can embed values (like string
;; interpolation): the $ character (unless it is followed by another
;; $) expects to be followed by an expression to be interpreted in the
;; current scope. At the time of parsing, they have also access to the
;; PENV (parser_environment) value that holds additional information
;; (LINE, FILE, POSITION, LOCATION, etc.); a shorthand notation $[v]
;; accesses those information.
;;
;; //!LOG: At $[LOCATION], value is $value
;;
;; More complex example, with conditional logging comments:
;;
;;     if (something_rare) {
;;        //!BREADCRUMB: something rare is true
;;     }
;;     
;;     if (another_corner_case) {
;;        //!BREADCRUMB: another strange thing happened
;;     }
;;     
;;     if (everything_ok) {
;;        //!BREADCRUMB: fine so far
;;        recurse()
;;     } else {
;;        //!BREADCRUMB: should not happen!
;;        //!SHOW_BREADCRUMB_TRAIL
;;
;;        // the above comment can also be done using code
;;        // (first-class!)
;;
;;        trail := comments().keep("BREADCRUMB").keep_if(active);
;;        map(print, trail);
;;
;;     }
;;
;
;; Inside our function, we add comments at different points ot the
;; program; in the last "else" branch, we notice a bug, and only when
;; this happens, we want to show all the ways the code went to reach
;; this state. All the previous BREADCRUMB comments that were visited
;; are now printed. When the code exits a function, it forgets about
;; all the visited notes (this is more powerful than a backtrace which
;; only shows the current stack for the line that detects an error).
;;
;; ATTACHING COMMENTS TO VALUES
;;
;; for example (pseudo-code), you can attach a "clean" label to
;; sanitized input, so that later you know the value can be used in a
;; safe way.
;;   
;;   sanitize_or_throw(in):
;;     out := ...
;;     //: clean
;;     return out
;;
;;   val := sanitize_or_throw(input())
;;
;;   ...
;;
;;   if (comments(val).find('clean')) {
;;     // trust it
;;   } else {
;;     // reject
;;   }
;;
;;  (same with currency, unit, etc.)

