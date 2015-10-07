;;;; csgjs.lisp

(in-package #:csgjs)

;;; "csgjs" goes here. Hacks and glory await!

(defclass csg () (polygons))

(defun new-csg (polygons)
  (make-instance 'csg :polygons polygons))

(defun csg-from-polygons (polygons) 
  (new-csg polygons))

(defgeneric clone (self))
(defgeneric to-polygons (self))
(defgeneric union (self other))
(defgeneric subtract (self other))
(defgeneric intersect (self other))


(defmethod clone ((self csg))
  (csg-from-polygons (slot-value self 'polygons)))

(defmethod to-polygons ((self csg))
  (slot-value self 'polygons))

(defmethod union ((self csg) (other csg))
  (let ((a (new-node :polygons (slot-value self 'polygons)))
        (b (new-node :polygons (slot-value other 'polygons))))
    (clipto a b)
    (clipto b a)
    (invert b)
    (clipto b a)
    (invert b)
    (build a (all-polygons b))
    (csg-from-polygons (all-polygons a))))

(defmethod subtract ((self csg) (other csg))
  (let ((a (make-instance 'node :polygons (slot-value self 'polygons)))
        (b (make-instance 'node :polygons (slot-value other 'polygons))))
    (invert a)
    (clipto a b)
    (clipto b a)
    (invert b)
    (clipto b a)
    (invert b)
    (build a (all-polygons b))
    (invert a)
    (csg-from-polygons (all-polygons a))))

(defmethod intersect ((self csg) (other csg))
  (let ((a (new-node :polygons (slot-value self 'polygons)))
        (b (new-node :polygons (slot-value other 'polygons))))
    (invert a)
    (clipto b a)
    (invert b)
    (clipto a b)
    (clipto b a)
    (build a (all-polygons b))
    (invert a)
    (csg-from-polygons (all-polygons a))))

(defmethod inverse ((self csg))
  (let ((csg (clone self)))
    (map nil (lambda (p) (flip p)) (polygons csg))
    csg))

(defun cube (&rest opt)
  (let* ((options (if (listp opt) opt nil))
         (c (make-instance 'csg-vector ))
         )
    
    )
  )

