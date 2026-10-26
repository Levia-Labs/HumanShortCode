import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

class VectorsTest {
    @Test
    fun vectors() {
        File("../../spec/vectors.tsv").readLines().forEachIndexed { i, line ->
            if (line.isEmpty() || line.startsWith("#")) return@forEachIndexed
            val f = line.split("\t")
            val alpha = if (f[2] == "-") HumanShortCode.DEFAULT_ALPHABET else f[2]
            val len = if (f[3] == "-") HumanShortCode.DEFAULT_LENGTH else f[3].toInt()
            val run = {
                when (f[0]) {
                    "encode" -> HumanShortCode.encode(f[1].toLong(), alpha, len)
                    "decode" -> HumanShortCode.decode(f[1], alpha, len).toString()
                    else -> HumanShortCode.verify(f[1], alpha, len).toString()
                }
            }
            if (f[4] == "!error") {
                val e = assertFailsWith<IllegalArgumentException>("line ${i + 1}") { run() }
                assertTrue(e.message!!.startsWith("human-short-code:"))
            } else {
                assertEquals(f[4], run(), "line ${i + 1}")
            }
        }
    }
}
