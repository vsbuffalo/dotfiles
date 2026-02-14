# Extract Mathematics from Code

Analyze model code and reverse-engineer the underlying mathematical framework.

## Objective

Read the modeling code in this repository and translate it into formal mathematical notation. Identify what type of model is being implemented and document the equations.

## Process

### Step 1: Find Model Code

Search for files likely to contain model definitions:
- Stan files (`.stan`) - probabilistic models
- Python files with modeling libraries (PyMC, scipy, numpy, tensorflow, jax)
- R files with statistical models (lme4, brms, rstanarm, stats)
- Jupyter notebooks with model fitting
- Files named `model*`, `likelihood*`, `objective*`, `loss*`

### Step 2: Analyze Each Model File

For each model file found, read it carefully and identify:

**Model Type:**
- Regression (linear, logistic, Poisson, etc.)
- Hierarchical/multilevel model
- Time series (ARIMA, state-space, etc.)
- Compartmental model (SIR, SEIR, etc.)
- Gaussian process
- Neural network
- Optimization problem
- Other

**Core Components:**
- What is the likelihood/loss function?
- What are the parameters being estimated?
- What are the priors (if Bayesian)?
- What are the covariates/predictors?
- What transformations are applied?

### Step 3: Translate to Mathematics

Convert code constructs to equations:

| Code Pattern | Mathematical Meaning |
|--------------|---------------------|
| `normal(mu, sigma)` | $X \sim \mathcal{N}(\mu, \sigma^2)$ |
| `y ~ dbinom(n, p)` | $Y \sim \text{Binomial}(n, p)$ |
| `np.dot(X, beta)` | $X\beta$ |
| `np.exp(x)` | $e^x$ |
| `scipy.integrate.odeint` | Numerical ODE solution |
| `optim(..., method='L-BFGS-B')` | Maximum likelihood via L-BFGS |

### Step 4: Document the Mathematics

Produce output in this format:

---

## Mathematical Model Summary

### Model Type
[e.g., "Bayesian hierarchical Poisson regression"]

### Model Specification

**Likelihood:**
$$
Y_i \sim \text{Distribution}(\theta_i)
$$

**Link function / transformation:**
$$
g(\theta_i) = \ldots
$$

**Linear predictor:**
$$
\eta_i = \ldots
$$

**Priors (if Bayesian):**
$$
\beta \sim \ldots
$$

### Parameters

| Symbol | Code Variable | Description | Constraints |
|--------|---------------|-------------|-------------|
| $\beta$ | `beta` | Regression coefficients | None |

### Data Inputs

| Symbol | Code Variable | Description |
|--------|---------------|-------------|
| $Y$ | `y` | Response variable |

### Inference Method
[e.g., "MCMC via NUTS sampler", "Maximum likelihood via Newton-Raphson"]

### Key Assumptions
- List assumptions implied by the model

---

## Guidelines

- Be precise: use the actual distributions and parameterizations from the code
- Note parameterization conventions (e.g., precision vs variance for normal)
- Identify hierarchical structure if present
- Flag any approximations or numerical methods
- If uncertain about a component, note the uncertainty

$arguments
Optional: Specific file or directory to analyze (defaults to searching entire repo)
