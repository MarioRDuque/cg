package com.mycompany.cg;

import java.io.IOException;
import java.util.Arrays;
import java.util.Random;

/**
 * Sistema inmune artificial - Algoritmo seleccion clonal
 *
 * @version 1.0
 */
public final class ClonAlg extends Algoritmo {

    // Cloned poblacion tamanio parametro
    private int paramβ;
    // Random anticuerpos por iteracion
    private int paramAnticuerposPorIteracion;
    // tamanio de la poblacion
    private int paramN;
    // Iteraciones
    private int iteraciones;
    // poblacion
    private Anticuerpo[] poblacion;
    // Cloned poblacion
    private Anticuerpo[] poblacionClonada;
    //  Rangos de poblacion clonada
    private int[] rangosDePoblacionClonada;
    // Tamanio de poblacion clonada
    private int tamanioPoblacionClonada;
    // generador de numeros aleatorios
    private Random rand;

    /**
     * Constructor
     */
    public ClonAlg() {
        paramN = 5;
        paramAnticuerposPorIteracion = 3;
        paramβ = 1;
        iteraciones = 10;
    }

    public ClonAlg(Individual bestIndividual) {
        this();
        setInitialIndividual(bestIndividual);
    }

    /**
     * El algoritmo de seleccion clonal
     */
    @Override
    public void run() {
        int iter = 0;
        inicializar();
        while (iter < iteraciones) {
            iter++;
            afinidad(poblacion);
            clonando();
            hipermutacion();
            afinidad(poblacionClonada);
            select();
            birthAndReplace();
            System.out.println("Iteración: " + iter + " Duracion(makespan): " + poblacion[0].getActualDuration());
            if (configuracion != null) {
                configuracion.increase();
            }
        }
        this.bestIndividual = (Individual) poblacion[0];
        System.out.println("ClonAlg Mejor Duracion - Menor makespan: " + this.bestIndividual.getActualDuration());
    }

    /**
     * Inicializacion de los parametros del algoritmo y poblacion, tambien
     * generamos la poblacion inicial de anticuerpos aleatorios
     */
    private void inicializar() {
        rand = new Random();
        poblacion = new Anticuerpo[paramN];
        tamanioPoblacionClonada = 0;
        for (int i = 1; i <= paramN; i++) {
            tamanioPoblacionClonada += (int) ((paramβ * paramN) / ((double) i) + 0.5);
        }
        poblacionClonada = new Anticuerpo[tamanioPoblacionClonada];
        rangosDePoblacionClonada = new int[tamanioPoblacionClonada];
        try {
            Anticuerpo anticuerpoInicial;
            if (initialIndividual == null) {//primera vez
                anticuerpoInicial = new Anticuerpo(Util.readInputFile());
            } else {
                anticuerpoInicial = new Anticuerpo(initialIndividual.clone().getProjectWorkLists());//trabajar con los clones
            }
            poblacion[0] = anticuerpoInicial;
            for (int i = 1; i < paramN; i++) {
                poblacion[i] = (Anticuerpo) anticuerpoInicial.clone();
                poblacion[i].randomizeAll();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Calcular afinidad (fitness) de todos anticuerpos
     *
     * @param poblacion the poblacion a ser evaluada
     */
    private void afinidad(Anticuerpo[] poblacion) {
        for (Anticuerpo anticuerpo : poblacion) {
            anticuerpo.calcularFitness();
        }
    }

    /**
     * Clonando proporcionalmente los anticuerpos en la poblacion, mejores
     * anticuerpos obtener más clones
     */
    private void clonando() {
        Arrays.sort(poblacion);
        int index = 0;
        for (int rank = 1; rank <= poblacion.length; rank++) {
            int copies = (int) ((paramβ * paramN) / ((double) rank) + 0.5);
            for (int copy = 0; copy < copies; copy++) {
                poblacionClonada[index] = (Anticuerpo) poblacion[rank - 1].clone();
                rangosDePoblacionClonada[index] = rank;
                index++;
            }
        }
    }

    /**
     *
     * Mutar anticuerpos de población clonados donde los anticuerpos mejores
     * mutan menos
     */
    private void hipermutacion() {
        double tau = 3.476 * (poblacion.length - 1);
        //  Dejamos intacto el mejor individuo, así que comenzamos con 1
        for (int index = 1; index < poblacionClonada.length; index++) {
            Anticuerpo currentAntibody = poblacionClonada[index];
            int rank = rangosDePoblacionClonada[index] - 1;
            int mutations = (int) (1 + 225 * 0.25 * (1 - Math.exp(-rank / tau)) + 0.5);
            currentAntibody.hyperMutate(mutations, rand);
        }
    }

    /**
     *
     * Selecciona N mejores individuos de la población clonada. N es el tamaño
     * de población normal.
     */
    private void select() {
        Arrays.sort(poblacionClonada);
        for (int index = 0; index < poblacion.length; index++) {
            poblacion[index] = poblacionClonada[index];
        }
    }

    /**
     *
     * Reemplaza los peores anticuerpos de paramAnticuerposPorIteracion en la
     * poblacion con los generados aleatoriamente
     */
    private void birthAndReplace() {
        int offset = poblacion.length - paramAnticuerposPorIteracion;
        for (int index = 0; index < paramAnticuerposPorIteracion; index++) {
            poblacion[offset + index].randomizeAll();
        }
    }

    /**
     *
     * Establecer el mejor individuo del algoritmo anterior si está encadenado
     *
     * @param initialIndividual
     */
    @Override
    public void setInitialIndividual(Individual initialIndividual) {
        this.initialIndividual = initialIndividual;
        inicializar();
    }

    /**
     *
     * @return
     */
    @Override
    public String toString() {
        return "ClonAlg";
    }

    // ------------------METHODS FOR GUI------------------
    // Iteraciones
    // [25-200]
    public int getIteraciones() {
        return iteraciones;
    }

    public void setIteraciones(int iterations) {
        this.iteraciones = iterations;
    }

    // β
    // [1-50]
    public int getParamβ() {
        return paramβ;
    }

    public void setParamβ(int paramβ) {
        this.paramβ = paramβ;
        inicializar();
    }

    // Random antibodies per iteration
    // [10-100]
    public int getParamAnticuerposPorIteracion() {
        return paramAnticuerposPorIteracion;
    }

    public void setParamAnticuerposPorIteracion(int paramD) {
        this.paramAnticuerposPorIteracion = paramD;
    }

    // Population size
    // [50-500]
    public int getParamN() {
        return paramN;
    }

    public void setParamN(int paramN) {
        this.paramN = paramN;
        inicializar();
    }

    // ----------------END METHODS FOR GUI-----------------
}
