;;;; test.lisp

;;;; ;;;;; BEGIN LICENSE BLOCK ;;;;;
;;;; 
;;;; Copyright (C) 2015 OpsResearch LLC (a Delaware company)
;;;; 
;;;; This program is free software: you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License, version 3,
;;;; as published by the Free Software Foundation.
;;;; 
;;;; This program is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;; 
;;;; ;;;;; END LICENSE BLOCK ;;;;;

(in-package #:or-test)

(defun test-glpk ()
  (5am:explain! (5am:run 'test-glpk)))

(5am:test test-glpk
          (or-glpk:with-problem 
            (problem :name "test-name" )
            (5am:is (equal (or-glpk:name problem) "test-name"))
            
            (or-glpk:read-mps
              problem
              (merge-pathnames
                (make-pathname :directory '(:relative "data") :name "test-1" :type "mps")
                (asdf:system-source-directory :or-glpk)
                ))
            
            (5am:is (equal (or-glpk:name problem) "TESTPROB"))		
            (or-glpk:write-cplex-lp problem #p"/tmp/cplex.lp")
            
            (or-glpk:with-problem 
              (cplex-problem)
              (or-glpk:read-cplex-lp cplex-problem #p"/tmp/cplex.lp"))))