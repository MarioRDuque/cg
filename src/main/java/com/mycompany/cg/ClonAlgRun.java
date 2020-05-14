package com.mycompany.cg;

import java.util.HashMap;
import java.util.Map;

import javax.swing.JProgressBar;

public class ClonAlgRun extends RunConfiguracion {

    public ClonAlgRun(Map<String, Algoritmo> algorithms) {
        super(algorithms);
    }

    public ClonAlgRun(Map<String, Algoritmo> algorithms, JProgressBar progress) {
        super(algorithms, progress);
    }

    @Override
    public String toString() {
        return "ClonAlg";
    }

    @Override
    protected void run() {

        // Algoritmo inicializacion
        ClonAlg clonAlg = (ClonAlg) algorithms.get("ClonAlg");
        clonAlg.setConfiguracion(this);

        // Maximum run iteraciones
        setMaxIterations(clonAlg.getIteraciones());

        clonAlg.run();
        runBestIndividual = clonAlg.getBestIndividual();

    }

    public static void main(String[] args) {

        Map<String, Algoritmo> algorithms = new HashMap<>();

        Algoritmo clonAlg = new ClonAlg();
        algorithms.put(clonAlg.toString(), clonAlg);

        RunConfiguracion clonAlgRun = new ClonAlgRun(algorithms);
        clonAlgRun.runConfiguration();

    }

}
