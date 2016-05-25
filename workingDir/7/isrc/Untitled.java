
public class Untitled {
  static {
    CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.ping();
  }

    
    public static int answer() {
byte CodeCoverLoopChoiceHelper_L1 = 0;


int CodeCoverConditionCoverageHelper_C1;
        CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[1]++;
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.loops[1]++;
for (int i=1;(((((CodeCoverConditionCoverageHelper_C1 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C1 |= (2)) == 0 || true) &&
 ((i<=100) && 
  ((CodeCoverConditionCoverageHelper_C1 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[1].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C1, 1) || true)) || (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[1].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C1, 1) && false); i++) {
if (CodeCoverLoopChoiceHelper_L1 == 0) {
  CodeCoverLoopChoiceHelper_L1++;
  CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.loops[1]--;
  CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.loops[2]++;
} else if (CodeCoverLoopChoiceHelper_L1 == 1) {
  CodeCoverLoopChoiceHelper_L1++;
  CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.loops[2]--;
  CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.loops[3]++;
}
int CodeCoverConditionCoverageHelper_C2;
            CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[2]++;
if((((((CodeCoverConditionCoverageHelper_C2 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C2 |= (2)) == 0 || true) &&
 ((0 == i % 15) && 
  ((CodeCoverConditionCoverageHelper_C2 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[2].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C2, 1) || true)) || (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[2].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C2, 1) && false)) {
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.branches[1]++; CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[3]++;
System.out.println("FizzBuzz");
}
            else {
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.branches[2]++;
int CodeCoverConditionCoverageHelper_C3; CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[4]++;
if ((((((CodeCoverConditionCoverageHelper_C3 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C3 |= (2)) == 0 || true) &&
 ((0 == i % 3) && 
  ((CodeCoverConditionCoverageHelper_C3 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[3].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C3, 1) || true)) || (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[3].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C3, 1) && false)) {
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.branches[3]++; CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[5]++;
System.out.println("Fizz");
}
            else {
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.branches[4]++;
int CodeCoverConditionCoverageHelper_C4; CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[6]++;
if ((((((CodeCoverConditionCoverageHelper_C4 = 0) == 0) || true) && (
(((CodeCoverConditionCoverageHelper_C4 |= (2)) == 0 || true) &&
 ((0 == i % 5) && 
  ((CodeCoverConditionCoverageHelper_C4 |= (1)) == 0 || true)))
)) && (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[4].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C4, 1) || true)) || (CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.conditionCounters[4].incrementCounterOfBitMask(CodeCoverConditionCoverageHelper_C4, 1) && false)) {
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.branches[5]++; CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[7]++;
System.out.println("Buzz");
}
            else {
CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.branches[6]++; CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[8]++;
System.out.println(i);
}
}
}
        }

        CodeCoverCoverageCounter$i882wnhuo7psfts7dffl.statements[9]++;
return 1;
    }
}

class CodeCoverCoverageCounter$i882wnhuo7psfts7dffl extends org.codecover.instrumentation.java.measurement.CounterContainer {

  static {
    org.codecover.instrumentation.java.measurement.ProtocolImpl.getInstance(org.codecover.instrumentation.java.measurement.CoverageResultLogFile.getInstance(null), "5e0699bc-e5c9-4a6e-9b14-333405742263").addObservedContainer(new CodeCoverCoverageCounter$i882wnhuo7psfts7dffl ());
  }
    public static long[] statements = new long[10];
    public static long[] branches = new long[7];

  public static final org.codecover.instrumentation.java.measurement.ConditionCounter[] conditionCounters = new org.codecover.instrumentation.java.measurement.ConditionCounter[5];
  static {
    final String SECTION_NAME = "Untitled.java";
    final byte[] CONDITION_COUNTER_TYPES = {0,1,1,1,1};
    for (int i = 1; i <= 4; i++) {
      switch (CONDITION_COUNTER_TYPES[i]) {
        case 0 : break;
        case 1 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.SmallOneConditionCounter(SECTION_NAME, "C" + i); break;
        case 2 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.SmallTwoConditionCounter(SECTION_NAME, "C" + i); break;
        case 3 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.MediumConditionCounter(SECTION_NAME, "C" + i); break;
        case 4 : conditionCounters[i] = new org.codecover.instrumentation.java.measurement.LargeConditionCounter(SECTION_NAME, "C" + i); break;
      }
    }
  }
    public static long[] loops = new long[4];

  public CodeCoverCoverageCounter$i882wnhuo7psfts7dffl () {
    super("Untitled.java");
  }

  public static void ping() {/* nothing to do*/}

  public void reset() {
      for (int i = 1; i <= 9; i++) {
        statements[i] = 0L;
      }
      for (int i = 1; i <= 6; i++) {
        branches[i] = 0L;
      }
    for (int i = 1; i <= 4; i++) {
      if (conditionCounters[i] != null) {
        conditionCounters[i].reset();
      }
    }
      for (int i = 1; i <= 3; i++) {
        loops[i] = 0L;
      }
  }

  public void serializeAndReset(org.codecover.instrumentation.measurement.CoverageCounterLog log) {
    log.startNamedSection("Untitled.java");
      for (int i = 1; i <= 9; i++) {
        if (statements[i] != 0L) {
          log.passCounter("S" + i, statements[i]);
          statements[i] = 0L;
        }
      }
      for (int i = 1; i <= 6; i++) {
        if (branches[i] != 0L) {
          log.passCounter("B"+ i, branches[i]);
          branches[i] = 0L;
        }
      }
    for (int i = 1; i <= 4; i++) {
      if (conditionCounters[i] != null) {
        conditionCounters[i].serializeAndReset(log);
      }
    }
      for (int i = 1; i <= 1; i++) {
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

