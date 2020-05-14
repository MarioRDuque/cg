package com.mycompany.cg;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.swing.JProgressBar;

/**
 * RunConfiguracion
 *
 * @version 1.0
 */
public abstract class RunConfiguracion {

    protected Individual runBestIndividual = null;
    protected Map<String, Algoritmo> algorithms;

    protected int maxIterations;
    protected int iteration;

    private JProgressBar progress = null;

    public RunConfiguracion(Map<String, Algoritmo> algorithms) {
        super();
        this.algorithms = algorithms;
    }

    public RunConfiguracion(Map<String, Algoritmo> algorithms,
            JProgressBar progress) {
        super();
        this.algorithms = algorithms;
        this.progress = progress;
    }

    public Individual getRunBestIndividual() {
        return runBestIndividual;
    }

    public void increase() {
        iteration++;
        if (progress != null) {
            progress.setValue(iteration);
        }

    }

    public void runConfiguration() {

        clear();
        this.run();
        try {

            if (runBestIndividual == null) {
                throw new IOException("No run best individual");
            }

            Set<Individual> bestIndividuals = new TreeSet<Individual>();

            File inputFolder = new File("results/input");
            File outputFolder = new File("results/output");
            if (!inputFolder.exists()) {
                inputFolder.mkdirs();
            }
            if (!outputFolder.exists()) {
                outputFolder.mkdirs();
            }

            for (File file : inputFolder.listFiles()) {
                Individual individual = new Individual(Util.readInputFile());
                individual.calcularFitness();
                bestIndividuals.add(individual);
            }

            runBestIndividual.calcularFitness();
            runBestIndividual.writeInputFile(
                    "results/input/HMO-projekt-input-last.txt"
            );
            runBestIndividual.writeOutputFile(
                    "results/output/HMO-projekt-output-last.txt"
            );
            bestIndividuals.add(runBestIndividual);

            int rank = 1;
            for (Individual individual : bestIndividuals) {

                if (rank <= 5) {
                    individual.writeInputFile(
                            "results/input/HMO-projekt-input-" + rank + ".txt"
                    );
                    individual.writeOutputFile(
                            "results/output/HMO-projekt-output-" + rank + ".txt"
                    );
                    rank++;
                }

            }

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    @Override
    public abstract String toString();

    private void clear() {
        iteration = 0;
        maxIterations = 100;
    }

    protected abstract void run();

    protected void setMaxIterations(int maxIterations) {
        this.maxIterations = maxIterations;
        if (progress != null) {
            progress.setMaximum(maxIterations);
        }
    }

}
