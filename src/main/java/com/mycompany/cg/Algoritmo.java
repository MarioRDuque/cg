package com.mycompany.cg;

/**
 * Algoritmo
 *
 * @author Ivo Majić, ivo.majic2@fer.hr
 * @version 1.0
 */
public abstract class Algoritmo {

    protected Individual bestIndividual = null;
    protected Individual initialIndividual = null;
    protected RunConfiguracion configuracion = null;

    public Individual getBestIndividual() {
        return bestIndividual;
    }

    public abstract void run();

    public void setInitialIndividual(Individual initialIndividual) {
    }

    @Override
    public abstract String toString();

    public void setConfiguracion(RunConfiguracion configuracion) {
        this.configuracion = configuracion;
    }

}
