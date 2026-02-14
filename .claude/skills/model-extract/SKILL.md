### Extract Scientific Models & Mathematics from a Repository

Analyze a scientific modeling codebase and reverse-engineer **all** implemented model(s) into a rigorous specification: **mathematics, algorithms, data flow, inference/estimation**, and **known uncertainties / red flags**.

### Operating Principles (must follow)

* **No guessing:** If you haven’t found the defining code, say so and list what’s missing.
* **Evidence-first:** Every key equation/claim should cite the *specific file + symbol/variable/function* it came from (and ideally line refs if available).
* **Separate “observed” vs “inferred”:**

  * *Observed in code* (high confidence)
  * *Inferred from patterns* (medium)
  * *Speculative / unclear* (low)
* **Model inventory over monolith:** Repos often contain multiple models, variants, or “half-implemented” ideas. Enumerate them.
* **Prefer minimal, targeted reads:** Don’t slurp the whole repo; locate model entrypoints and follow the call graph.

---

## Step 0: Establish the “Model Boundary”

Identify:

* What counts as the **model definition** (mechanistic rules / likelihood / objective)
* What is **inference/optimization** (sampler, optimizer, calibration)
* What is **data plumbing** (ETL, I/O, plotting)
* What is **simulation runtime** (time stepping, random seeds, parallelism)

Output:

* A short map of directories/files by role.

---

## Step 1: Locate Model Entry Points

Search for:

* Probabilistic models: `.stan`, PyMC, NumPyro, TFP, Turing.jl, brms/rstanarm
* Mechanistic models: ODE/PDE solvers (`odeint`, `solve_ivp`, DifferentialEquations.jl), compartment frameworks
* ABMs: agent classes, event loops, schedulers, hazard functions, Gillespie/SSA, discrete-time updates
* Calibration/inference: likelihood/objective, loss, priors, posterior, MCMC config, optimizer calls
* “Run” surfaces: CLI entrypoints, notebooks, `main()`, `run_*`, `simulate_*`, pipelines, workflows

Deliverable:

* **Model Inventory Table** (one row per distinct model/variant)

| Model ID | Type           | Primary files | Entrypoint | Status                       |
| -------- | -------------- | ------------- | ---------- | ---------------------------- |
| M1       | e.g., SEIR ODE | …             | …          | implemented / partial / dead |

---

## Step 2: For Each Model, Extract a Formal Spec

### 2A) Identify model class

Choose all that apply:

* Statistical (likelihood-based / Bayesian)
* Optimization / control
* ODE / PDE / difference equations
* State-space / HMM
* ABM / IBM / network simulation
* Hybrid (e.g., ABM with observation model)

### 2B) Build the “Generative Story” (even if frequentist)

**Data:** what is observed, at what resolution, with what missingness/censoring?
**Latents/states:** what is unobserved?
**Parameters:** what is estimated vs fixed?
**Stochasticity:** where randomness enters (process noise, observation noise, priors)

### 2C) Translate to Mathematics (required structure)

#### (i) Core state evolution (mechanistic)

* **ODE:**
  [
  \frac{d\mathbf{x}}{dt} = f(\mathbf{x}(t), \theta, t)
  ]
* **Discrete-time:**
  [
  \mathbf{x}_{t+1} = F(\mathbf{x}_t, \theta, t) + \varepsilon_t
  ]
* **Event-driven / hazards (ABM or CTMC):**
  For event (k) with hazard (h_k(\cdot)):
  [
  \Pr(\text{event }k \text{ in } [t,t+\Delta t]) \approx h_k(\text{state}_t,\theta),\Delta t
  ]

#### (ii) Observation / measurement model

[
y_i \sim p(y_i \mid \text{state}_i, \theta)
]
Include link functions and parameterization conventions.

#### (iii) Likelihood or objective

* **Likelihood:**
  [
  \mathcal{L}(\theta)=\prod_i p(y_i\mid \cdot)
  ]
* **Negative log-likelihood / loss:**
  [
  \ell(\theta) = -\sum_i \log p(y_i\mid \cdot)
  ]
* If simulation-based: define the estimator (synthetic likelihood, ABC distance, etc.).

#### (iv) Priors (if Bayesian)

[
\theta \sim p(\theta)
]
Be explicit about variance vs sd, precision forms, constraints, transforms.

#### (v) Inference / calibration algorithm

Specify *what’s actually done*:

* MCMC (NUTS/HMC/Gibbs): what target density, what tuning?
* VI: what variational family, what ELBO?
* Optimization: what optimizer, constraints, gradients, stopping
* Particle methods: number of particles, resampling, proposal

---

## Step 3: ABM/IBM-Specific Requirements (don’t hand-wave)

For ABMs, you must extract **both** a math description *and* an algorithmic one.

### 3A) Entities and state

* Agent state vector (s_i(t))
* Global state (G(t)) (environment, network, shared resources)

### 3B) Update semantics (choose one, justify from code)

* Synchronous discrete-time step
* Asynchronous updates within a step
* Continuous-time events (Gillespie/SSA / next reaction)

### 3C) Transition rules

Express each rule as:

* Preconditions
* Stochastic mechanism (Bernoulli, categorical, Poisson, hazard)
* State update function

Example pattern:
[
s_i(t+\Delta t)=U\big(s_i(t), G(t), \theta, \xi\big)
]
where (\xi) is the random draw.

### 3D) RNG and reproducibility

Extract:

* seed handling
* per-agent/per-event RNG streams (if any)
* parallelism effects on determinism

---

## Step 4: Uncertainty, Ambiguity, and “Red Flags” (mandatory output)

Produce three lists:

### (A) Ambiguities (need human answer)

* “Parameter `kappa` used but never documented; could be X or Y”
* “Two competing implementations exist; unclear which is used in runs”

### (B) Potential bugs / model-spec mismatches

* Units inconsistencies
* Probability > 1, negative rates
* Off-by-one time indexing
* Priors incompatible with constraints
* Silent clipping / ad-hoc epsilons

### (C) Scientific risks / identifiability concerns (if inferable)

* Non-identifiability
* Weakly identified parameters
* Likelihood misspecification
* Overfitting leakage (train/test bleed)

Each item must include:

* **Evidence pointer** (file/function/variable)
* **Severity** (low/med/high)
* **Confidence** (low/med/high)
* **Suggested check** (test, plot, derivation, unit audit)

---

## Step 5: Deliverables (final report format)

### 1) Executive Summary

* Models found, purpose, main equations, biggest uncertainties.

### 2) Model Inventory

(Table)

### 3) Per-Model “Math Sheet” (repeatable template)

**Model ID / Name**
**Type**
**State evolution** (equations)
**Observation model**
**Likelihood / objective**
**Priors** (if any)
**Inference / calibration**
**Parameter table** (symbol ↔ code variable ↔ meaning ↔ constraints ↔ default/estimated)
**Data inputs table** (symbol ↔ file/column ↔ meaning)
**Assumptions**
**Uncertainties & flags**

### 4) Cross-cutting Notes

Shared utilities, common transforms, duplicated logic, versioned configs.

### 5) Validation Checklist

Concrete actions to verify the reverse-engineered spec:

* Reproduce one run end-to-end
* Unit tests for rates/links
* Simulate-from-prior / posterior predictive checks
* Sensitivity analysis targets

---

## Handy translation table (keep, but expand)

Include patterns for:

* GLMs (logit/log links)
* NB/Poisson parameterizations
* GP kernels
* State-space (transition + emission)
* ODE solvers (what numerical method + step control)
* ABM hazards vs per-timestep Bernoulli approximations

---

### Optional arguments

* Scope: directory/file glob(s)
* Target model ID(s)
* Desired output: Markdown / LaTeX / Quarto
* “Strict mode” (fail if any core piece is ambiguous)

---

## A couple of tactical Claude Code tips tailored to *this* skill

* Start each run with: **“Explore first; do not propose equations until you’ve located the model entrypoint(s).”** (This aligns with Anthropic’s own advice to prevent premature solutions.) ([Claude][2])
* Treat the official “explore unfamiliar code” workflow as your default outer loop. ([Claude Code][3])
* If you make this a real Claude Code workflow, put the “Operating Principles + Deliverables format” into `CLAUDE.md` so it’s always in force. ([Claude Code][1])

---

If you want, paste a repo link (or a file tree / key entrypoint files) and I’ll adapt this skill into a tighter version specialized for *your* typical modeling stack (Starsim-like ABMs + calibration + probabilistic observation models), including extra translation patterns that match what you actually see in practice.

[1]: https://code.claude.com/docs/en/best-practices?utm_source=chatgpt.com "Best Practices for Claude Code"
[2]: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices?utm_source=chatgpt.com "Prompting best practices - Claude API Docs"
[3]: https://code.claude.com/docs/en/common-workflows?utm_source=chatgpt.com "Common workflows - Claude Code Docs"
[4]: https://www.eesel.ai/blog/claude-code-best-practices?utm_source=chatgpt.com "My 7 essential Claude Code best practices for production-ready AI in 2025"

