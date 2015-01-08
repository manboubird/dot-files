/**
 *  Utilities for working with Scalding shell aka. `scald.rb --repl`
 *
 *    scalding> :load ScaldingShellUtils.scala
 *
 */
/*
you may require to load jars below:
  "org.json4s/json4s-core_2.10/3.2.11",
  "org.json4s/json4s-jackson_2.10/3.2.11",
  "org.json4s/json4s-scalaz_2.10/3.2.11",
  "org.json4s/json4s-ast_2.10/3.2.11",
  "com.thoughtworks.paranamer/paranamer/2.5",
  "org.scala-lang/scalap/2.10.3",
*/
object Scaldrc {

  import java.io.File
  import org.json4s._
  import org.json4s.jackson.JsonMethods._
  implicit val formats = DefaultFormats

  private def findAllUpPath(filename: String): List[File] = Iterator.iterate(System.getProperty("user.dir"))(new File(_).getParent)
      .takeWhile(_ != "/")
      .flatMap(new File(_).listFiles.filter(_.toString.endsWith(filename)))
      .toList

  val rcFile:File = findAllUpPath(".scaldrc").reverse.head

  private val swource = scala.io.Source.fromFile(rcFile.toString)
  private val json = parse(source.mkString)
  source.close()

  case class Scaldrc(host: String, repo_root: String, localmem: String, hadoop_opts: Map[String, String], module_jar_paths: List[String], depends: List[String],
    regex_match_jar_repositories: List[Map[String, String]], tmpdir:String)

  val data:Scaldrc = json.extract[Scaldrc]
}
