package com.example.test;

import static org.junit.Assert.assertEquals;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

public class BeforeAfterClassTests {

  @BeforeAll
  public static void doSomething() {
    // well actually do nothing except be here
  }

  @Test
  public void shouldKillMutant1() {
    assertEquals(1, CoveredByABeforeAfterClass.returnOne());
  }

  @Test
  public void shouldKillMutantAgainButShouldNotBeRun() {
    assertEquals(1, CoveredByABeforeAfterClass.returnOne());
  }
}
