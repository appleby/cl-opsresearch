;;;; problem.lisp

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
;;;; GNU Lesser General Public License for more details.
;;;; 
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;;; 
;;;; ;;;;; END LICENSE BLOCK ;;;;;

(in-package #:or-glpk)

(defclass Problem ()(
	(glp-prob :reader glp-prob :initarg glp-prob :initform (glp::create-prob))))

(defmethod initialize-instance :after ((p Problem) &key (name nil))
  (when name (glp:set-prob-name (glp-prob p) name )))

(defgeneric glp-prob-delete (problem))
(defmethod glp-prob-delete ((problem Problem))
	(glp:delete-prob (glp-prob problem)))

(defmacro with-problem ((var &rest init-options) &body body)
    (let ((obj (gensym)))
      `(let (,var ,obj)
         (unwind-protect
             (progn (setq ,obj (make-instance 'problem ,@init-options)
                          ,var ,obj)
                    ,@body)
           (unless (null ,obj)
             (glp-prob-delete ,obj))))))
