/*
 * Copyright (C) 2009, Progress Software Corporation and/or its
 * subsidiaries or affiliates.  All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.fusesource.forge.jmstest.probe;

import java.util.Observable;
import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fusesource.forge.jmstest.probe.BenchmarkProbeValue.ValueType;

public abstract class AbstractProbe extends Observable implements Probe {

  private ProbeDescriptor descriptor = null;
  private String name;
  private boolean resetOnRead = false;
  private boolean active = true;
  private int inactiveAfterException = 5;
  protected long lastException = Long.MIN_VALUE;

  private Log log = null;

  public AbstractProbe() {
    this("Probe-" + UUID.randomUUID().toString());
  }

  public AbstractProbe(String name) {
    this.name = name;
  }

  public final BenchmarkProbeValue getProbeValue() {

    Number value = null;

    try {
      value = getValue();
    } catch (Exception e) {
      log().warn("Exception reading probe " + getDescriptor());
      lastException = System.currentTimeMillis();
      setActive(false);
    }

    BenchmarkProbeValue result = new BenchmarkProbeValue(
      getDescriptor(), System.currentTimeMillis() / 1000, value
    );

    if (isResetOnRead()) {
      reset();
    }
    return result;
  }

  protected abstract Number getValue() throws Exception;

  public void setName(String name) {
    this.name = name;
    descriptor = null;
  }

  public String getName() {
    return name;
  }

  public void setActive(boolean active) {
    this.active = active;
  }

  public boolean isActive() {
    if (active) {
      return true;
    } else {
      if (System.currentTimeMillis() - lastException > getInactiveAfterException() * 1000L) {
        setActive(true);
        return true;
      } else {
        return false;
      }
    }
  }

  public int getInactiveAfterException() {
    return inactiveAfterException;
  }

  public void setInactiveAfterException(int inactiveAfterException) {
    this.inactiveAfterException = inactiveAfterException;
  }

  public boolean isResetOnRead() {
    return resetOnRead;
  }

  public void setResetOnRead(boolean resetOnRead) {
    this.resetOnRead = resetOnRead;
  }

  public void reset() {
  }

  public BenchmarkProbeValue.ValueType getValueType() {
    return ValueType.GAUGE;
  }

  public ProbeDescriptor getDescriptor() {
    if (descriptor == null) {
      descriptor = new ProbeDescriptor(this);
    }
    return descriptor;
  }

  public void probe() {
    BenchmarkProbeValue value = getProbeValue();
    log().debug("Probe: " + getName() + "=" + value);
    setChanged();
    notifyObservers(value);
  }

  private Log log() {
    if (log == null) {
      log = LogFactory.getLog(this.getClass());
    }
    return log;
  }
}
