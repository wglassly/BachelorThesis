package thu.ailab.template

import scala.collection.mutable.ArrayBuffer

import thu.ailab.tree.TreeNode
import thu.ailab.global.MyConfigFactory

class TagSeqShingles (treeNodeArray: Array[TreeNode]) {
  val shingleLength = MyConfigFactory.getValue[Int]("template.shingleLength")
  private var preDepth = -1
  private val nodeStack = new ArrayBuffer[TreeNode]
  private val shingleBuffer = new ArrayBuffer[Shingle]
  private val fatherArray = new ArrayBuffer[TreeNode]
  for (tn <- treeNodeArray) {
    if (tn.depth >= preDepth) {
      nodeStack += tn
    } else {
      shingleBuffer ++= nodeStack.grouped(shingleLength).map { x =>
        new Shingle(x.toArray)
      }
      nodeStack.clear()
      nodeStack += tn
    }
    preDepth = tn.depth
  }
  if (!nodeStack.isEmpty) {
    shingleBuffer ++= nodeStack.grouped(shingleLength).map { x =>
      new Shingle(x.toArray)
    }
  }
  val shingles = shingleBuffer.toArray
  override def toString() = {
    shingles mkString " | "
  }
}