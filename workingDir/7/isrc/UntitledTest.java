import org.junit.*;
import static org.junit.Assert.*;

public class UntitledTest {
  static {
    CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.ping();
  }

    
    @Test
    public void hitch_hiker() {
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[1]++;
int expected = 6 * 9;
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[2]++;
int actual = Untitled.answer();
        CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h.statements[3]++;
assertEquals(expected, actual);
    }
}

class CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h extends org.codecover.instrumentation.java.measurement.CounterContainer {

  static {
    org.codecover.instrumentation.java.measurement.ProtocolImpl.getInstance(org.codecover.instrumentation.java.measurement.CoverageResultLogFile.getInstance(null), "5e0699bc-e5c9-4a6e-9b14-333405742263").addObservedContainer(new CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h ());
  }
    public static long[] statements = new long[4];
    public static long[] branches = new long[0];
    public static long[] loops = new long[1];

  public CodeCoverCoverageCounter$zys7vdtc8b9l953x8lwlvjab8h () {
    super("UntitledTest.java");
  }

  public static void ping() {/* nothing to do*/}

  public void reset() {
      for (int i = 1; i <= 3; i++) {
        statements[i] = 0L;
      }
      for (int i = 1; i <= -1; i++) {
        branches[i] = 0L;
      }
      for (int i = 1; i <= 0; i++) {
        loops[i] = 0L;
      }
  }

  public void serializeAndReset(org.codecover.instrumentation.measurement.CoverageCounterLog log) {
    log.startNamedSection("UntitledTest.java");
      for (int i = 1; i <= 3; i++) {
        if (statements[i] != 0L) {
          log.passCounter("S" + i, statements[i]);
          statements[i] = 0L;
        }
      }
      for (int i = 1; i <= -1; i++) {
        if (branches[i] != 0L) {
          log.passCounter("B"+ i, branches[i]);
          branches[i] = 0L;
        }
      }
      for (int i = 1; i <= 0; i++) {
        if (loops[i * 3 - 2] != 0L) {
          log.passCounter("L" + i + "-0", loops[i * 3 - 2]);
          loops[i * 3 - 2] = 0L;
        }
        if ( loops[i * 3 - 1] != 0L) {
          log.passCounter("L" + i + "-1", loops[i * 3 - 1]);
          loops[i * 3 - 1] = 0L;
        }
        if ( loops[i * 3] != 0L) {
          log.passCounter("L" + i + "-2", loops[i * 3]);
          loops[i * 3] = 0L;
        }
      }
  }
}

