;;;; albion-trader.asd

(asdf:defsystem #:albion-trader
  :description "Describe albion-trader here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:lquery #:dexador #:yason #:str-tools #:clods-export)
  :components ((:file "package")
               (:file "albion-trader")
	       (:file "item-base")
	       (:file "requests")))
