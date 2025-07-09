;;; sandbox.el -*- lexical-binding: t; -*-


;;; (describe-theme (nth 1 (custom-available-themes)))



(defun two-fer (&optional word)
;;; exercism --- two-fer
;;; Code: word - name as an argument, can be omitted
;;;
  (format "One for %s, one for me."
          (if (or
               (eq word nil)
               (string= "" word))
              "you"
              word)))

;;;     on every year that is evenly divisible by 4
;;;     except every year that is evenly divisible by 100
;;;     unless the year is also evenly divisible by 400

year % 4 === 0

(defun leap-year-p (year)

  ;; (equal (% 100 year) 0)
  )

(defun dough-calculator (pizzas diameter) (
  (* pizzas (+ (/ (* 45 pi diameter) 20) 200))
))

(dough-calculator 4 30)

(leap-year-p 1996) ; +
(leap-year-p 1997) ; -
(leap-year-p 1900) ; -
(leap-year-p 2000) ; +






