import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:quiz_app_pilot/models/Questions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quiz_app_pilot/screens/welcome/score/score_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  // Lets animated our progress bar
  final String level;
  late AnimationController _animationController;
  late Animation _animation;

  QuestionController(this.level);
  // so that we can access our animation outside
  Animation get animation => this._animation;

  late PageController _pageController;
  RxList _questions = [].obs;

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('physics_mcqs');
  PageController get pageController => this._pageController;

  RxList get questions => this._questions;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  int _correctAns = 0;
  int get correctAns => this._correctAns;

  late int _selectedAns;
  int get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  List sample_data = [
    {
      "id": 91,
      "question":
          "What is the equation for the kinetic energy of a moving object?",
      "options": ["KE = 1/2 mv^2", "E = mc^2", "F = ma", "P = mv"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 92,
      "question":
          "What is the difference between potential energy and kinetic energy?",
      "options": [
        "Potential energy is the energy stored in an object due to its position, while kinetic energy is the energy of an object due to its motion.",
        "Potential energy is the energy stored in an object due to its motion, while kinetic energy is the energy of an object due to its position.",
        "Potential energy and kinetic energy are the same thing.",
        "There is no difference between potential energy and kinetic energy."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 93,
      "question": "What is the law of conservation of energy?",
      "options": [
        "The total energy of an isolated system remains constant.",
        "The total momentum of an isolated system remains constant.",
        "The total mass of an isolated system remains constant.",
        "The total charge of an isolated system remains constant."
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 94,
      "question": "What is the equation for the work done by a force?",
      "options": ["W = Fd", "W = mgh", "KE = 1/2 mv^2", "E = mc^2"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 95,
      "question": "What is the difference between heat and temperature?",
      "options": [
        "Heat is the transfer of energy between two objects, while temperature is a measure of the average kinetic energy of the particles in an object.",
        "Heat is a measure of the average kinetic energy of the particles in an object, while temperature is the transfer of energy between two objects.",
        "Heat and temperature are the same thing.",
        "There is no difference between heat and temperature."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 96,
      "question": "What is the equation for the ideal gas law?",
      "options": ["PV = nRT", "W = Fd", "KE = 1/2 mv^2", "E = mc^2"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 97,
      "question": "What is the difference between sound and light?",
      "options": [
        "Sound is a wave that travels through a medium, while light is a wave that does not require a medium to travel.",
        "Sound is a wave that does not require a medium to travel, while light is a wave that travels through a medium.",
        "Sound and light are the same thing.",
        "There is no difference between sound and light."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 98,
      "question": "What is the equation for the speed of sound?",
      "options": ["v = fλ", "v = √(E/m)", "KE = 1/2 mv^2", "E = mc^2"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 99,
      "question": "What is the equation for the speed of light?",
      "options": ["v = fλ", "v = √(E/m)", "c = √(μ0ε0)", "KE = 1/2 mv^2"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 100,
      "question": "What is the law of refraction?",
      "options": [
        "The angle of incidence is equal to the angle of refraction.",
        "The angle of incidence is greater than the angle of refraction.",
        "The angle of incidence is less than the angle of refraction.",
        "There is no relation between the angle of incidence and the angle of refraction."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 101,
      "question": "What is a lens?",
      "options": [
        "A lens is a device that bends light rays.",
        "A lens is a device that reflects light rays.",
        "A lens is a device that absorbs light rays.",
        "A lens is a device that scatters light rays."
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 102,
      "question": "What are the three types of lenses?",
      "options": [
        "Convex lens, concave lens, and plane lens",
        "Concave lens, convex lens, and diverging lens",
        "Convex lens, diverging lens, and plane lens",
        "Plane lens, converging lens, and diverging lens"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 103,
      "question":
          "What is the difference between a convex lens and a concave lens?",
      "options": [
        "A convex lens is thicker in the middle than at the edges, while a concave lens is thinner in the middle than at the edges.",
        "A convex lens converges light rays, while a concave lens diverges light rays.",
        "A convex lens reflects light rays, while a concave lens absorbs light rays.",
        "A convex lens scatters light rays, while a concave lens refracts light rays."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 104,
      "question": "What is a mirage?",
      "options": [
        "An optical illusion caused by the refraction of light by hot air.",
        "An optical illusion caused by the reflection of light by hot air.",
        "An optical illusion caused by the absorption of light by hot air.",
        "An optical illusion caused by the scattering of light by hot air."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 105,
      "question": "What is a rainbow?",
      "options": [
        "An optical illusion caused by the refraction of light by water droplets.",
        "An optical illusion caused by the reflection of light by water droplets.",
        "An optical illusion caused by the absorption of light by water droplets.",
        "An optical illusion caused by the scattering of light by water droplets."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 106,
      "question": "What is the difference between a rainbow and a halo?",
      "options": [
        "A rainbow is a circular arc of colors, while a halo is a ring of colors around the sun or moon.",
        "A rainbow is caused by the refraction of light by water droplets, while a halo is caused by the reflection of light by ice crystals.",
        "A rainbow is caused by the absorption of light by water droplets, while a halo is caused by the scattering of light by ice crystals.",
        "A rainbow is caused by the scattering of light by water droplets, while a halo is caused by the refraction of light by ice crystals."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 107,
      "question": "What is a lens formula?",
      "options": [
        "f = (uv)/(u - v)",
        "f = (u + v)/(u - v)",
        "f = uv/(u + v)",
        "f = u/v"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 108,
      "question": "What is the power of a lens?",
      "options": [
        "The power of a lens is the reciprocal of its focal length.",
        "The power of a lens is the product of its focal length and its aperture.",
        "The power of a lens is the square of its focal length.",
        "The power of a lens is the sum of its focal length and its aperture."
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 109,
      "question": "What is the unit of power of a lens?",
      "options": ["Diopter", "Newton", "Kilogram", "Meter"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 110,
      "question": "What is a microscope?",
      "options": [
        "A microscope is a device that uses lenses to magnify objects.",
        "A microscope is a device that uses mirrors to magnify objects.",
        "A microscope is a device that uses electricity to magnify objects.",
        "A microscope is a device that uses sound waves to magnify objects."
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 111,
      "question": "What are the two main types of microscopes?",
      "options": [
        "Compound microscope and optical microscope",
        "Compound microscope and electron microscope",
        "Optical microscope and scanning electron microscope",
        "Transmission electron microscope and scanning electron microscope"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 112,
      "question":
          "What is the difference between a compound microscope and an optical microscope?",
      "options": [
        "A compound microscope uses two or more lenses to magnify objects, while an optical microscope uses only one lens to magnify objects.",
        "A compound microscope uses a beam of electrons to magnify objects, while an optical microscope uses a beam of light to magnify objects.",
        "A compound microscope is used to magnify objects in the visible light spectrum, while an optical microscope is used to magnify objects in the ultraviolet light spectrum.",
        "A compound microscope is used to magnify objects in the infrared light spectrum, while an optical microscope is used to magnify objects in the visible light spectrum."
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 113,
      "question": "What is the maximum magnification of a compound microscope?",
      "options": ["1,000x", "10,000x", "100,000x", "1,000,000x"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 114,
      "question": "What is an electron microscope?",
      "options": [
        "A microscope that uses a beam of electrons to magnify objects.",
        "A microscope that uses a beam of light to magnify objects.",
        "A microscope that uses a beam of sound waves to magnify objects.",
        "A microscope that uses a beam of electricity to magnify objects."
      ],
      "answer_index": 1,
      "level": "Easy"
    },

    {
      "id": 115,
      "question": "What are the two main types of electron microscopes?",
      "options": [
        "Transmission electron microscope and scanning electron microscope",
        "Optical microscope and scanning electron microscope",
        "Compound microscope and transmission electron microscope",
        "Transmission electron microscope and scanning tunneling microscope"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 116,
      "question":
          "What is the phenomenon where a wave's frequency appears to decrease as the source approaches an observer?",
      "options": [
        "Doppler effect",
        "Interference",
        "Diffraction",
        "Refraction"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 117,
      "question": "What does the acronym LASER stand for?",
      "options": [
        "Light Amplification by Stimulated Emission of Radiation",
        "Luminous Array of Sequential Emission of Radiation",
        "Lightwave And Soundwave Emitting Radiation",
        "Light Analysis for Spectral Emission and Reflection"
      ],
      "answer_index": 0,
      "level": "Hard"
    },
    {
      "id": 118,
      "question":
          "What is the unit of measurement for electric potential difference?",
      "options": ["Ohm", "Watt", "Ampere", "Volt"],
      "answer_index": 3,
      "level": "Easy"
    },
    {
      "id": 119,
      "question":
          "Which law describes the relationship between a force applied to an object and its resulting acceleration?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 120,
      "question":
          "What type of lens is thicker at the center than at the edges?",
      "options": [
        "Concave lens",
        "Convex lens",
        "Plano-convex lens",
        "Plano-concave lens"
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 121,
      "question":
          "What phenomenon occurs when light waves change direction as they pass from one medium to another?",
      "options": ["Reflection", "Refraction", "Diffraction", "Interference"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 122,
      "question":
          "Which law of thermodynamics states that energy cannot be created or destroyed, only transferred or converted?",
      "options": ["Zeroth Law", "First Law", "Second Law", "Third Law"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 123,
      "question":
          "What is the process of converting a solid directly into a gas called?",
      "options": ["Evaporation", "Sublimation", "Condensation", "Vaporization"],
      "answer_index": 1,
      "level": "Hard"
    },
    {
      "id": 124,
      "question": "What type of wave does not require a medium to propagate?",
      "options": [
        "Sound wave",
        "Light wave",
        "Mechanical wave",
        "Electromagnetic wave"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 125,
      "question":
          "What property of a material determines how much it will resist the flow of electric current?",
      "options": ["Conductance", "Resistance", "Reactance", "Impedance"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 126,
      "question":
          "What is the phenomenon where a vibrating system or external force drives another system to oscillate with greater amplitude at a specific frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 127,
      "question": "What type of particles are found in an atom's nucleus?",
      "options": ["Electrons", "Protons", "Neutrons", "Positrons"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 128,
      "question": "What does the acronym MRI stand for in medical imaging?",
      "options": [
        "Medical Radiology Imaging",
        "Magnetic Resonance Imaging",
        "Microscopic Radiographic Imaging",
        "Molecular Radiology Investigation"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 129,
      "question":
          "Which physical quantity is defined as the amount of matter in an object?",
      "options": ["Weight", "Mass", "Density", "Volume"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 130,
      "question": "What is the SI unit of work and energy?",
      "options": ["Joule", "Watt", "Volt", "Newton"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 131,
      "question":
          "What is the process by which a liquid changes into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 132,
      "question":
          "What law states that the pressure of a gas is inversely proportional to its volume at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 133,
      "question":
          "What is the force of attraction between any two masses in the universe?",
      "options": [
        "Centrifugal force",
        "Electromagnetic force",
        "Gravitational force",
        "Nuclear force"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 134,
      "question": "What does the acronym AC stand for in electricity?",
      "options": [
        "Alternating Current",
        "Amplified Current",
        "Advanced Circuit",
        "Atomic Charge"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 135,
      "question": "What is the fundamental unit of electric charge?",
      "options": ["Electron", "Neutron", "Proton", "Photon"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 136,
      "question": "What is the speed of light in a vacuum?",
      "options": [
        "299,792,458 m/s",
        "300,000,000 m/s",
        "200,000,000 m/s",
        "250,000,000 m/s"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 137,
      "question":
          "Which force is responsible for keeping planets in orbit around the sun?",
      "options": [
        "Gravitational force",
        "Electromagnetic force",
        "Nuclear force",
        "Centrifugal force"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 138,
      "question":
          "What law states that the entropy of an isolated system will always increase over time?",
      "options": [
        "First law of thermodynamics",
        "Second law of thermodynamics",
        "Third law of thermodynamics",
        "Zeroth law of thermodynamics"
      ],
      "answer_index": 1,
      "level": "Hard"
    },
    {
      "id": 139,
      "question": "What is the SI unit of frequency?",
      "options": ["Hertz", "Watt", "Joule", "Newton"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 140,
      "question": "What type of energy does an object in motion possess?",
      "options": [
        "Potential energy",
        "Mechanical energy",
        "Kinetic energy",
        "Thermal energy"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 141,
      "question": "What does the law of conservation of energy state?",
      "options": [
        "Energy can be created but not destroyed",
        "Energy cannot be created or destroyed, only converted",
        "Energy can be destroyed but not created",
        "Energy is constant within a closed system"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 142,
      "question":
          "What type of mirror curves outward and forms a virtual image that is smaller than the object?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 143,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Dalton's law"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 144,
      "question":
          "What is the minimum speed needed for an object to escape the gravitational pull of a celestial body?",
      "options": [
        "Escape velocity",
        "Terminal velocity",
        "Critical velocity",
        "Orbital velocity"
      ],
      "answer_index": 0,
      "level": "Hard"
    },
    {
      "id": 145,
      "question": "What is the SI unit of pressure?",
      "options": ["Pascal", "Newton", "Joule", "Watt"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 146,
      "question":
          "Which phenomenon causes an apparent change in the frequency of a sound wave as the source and observer move relative to each other?",
      "options": [
        "Doppler effect",
        "Interference",
        "Diffraction",
        "Refraction"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 147,
      "question": "What does the term 'quantum' refer to in quantum mechanics?",
      "options": [
        "A unit of energy",
        "A subatomic particle",
        "A discrete quantity of matter",
        "A fundamental aspect of light"
      ],
      "answer_index": 2,
      "level": "Hard"
    },
    {
      "id": 148,
      "question":
          "What is the bending of light waves around obstacles or edges called?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 149,
      "question":
          "What law states that the volume of a given mass of gas is directly proportional to its absolute temperature at constant pressure?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 150,
      "question":
          "What is the process by which a gas changes directly into a solid without passing through the liquid state?",
      "options": ["Deposition", "Sublimation", "Condensation", "Evaporation"],
      "answer_index": 0,
      "level": "Hard"
    },
    {
      "id": 151,
      "question":
          "What is the principle that states that a fluid in equilibrium within a container exerts pressure equally in all directions?",
      "options": [
        "Bernoulli's principle",
        "Archimedes' principle",
        "Pascal's principle",
        "Newton's principle"
      ],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 152,
      "question":
          "What is the name of the subatomic particles that have no electric charge and contribute to the mass of an atom?",
      "options": ["Protons", "Neutrons", "Electrons", "Quarks"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 153,
      "question":
          "What is the process by which an atom or molecule gains energy and moves to a higher energy state?",
      "options": ["Ionization", "Excitation", "Fusion", "Fission"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 154,
      "question":
          "What is the phenomenon where the amplitude of a vibrating system increases when the frequency of its forced vibrations matches its natural frequency?",
      "options": ["Oscillation", "Damping", "Resonance", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 155,
      "question":
          "What is the process by which an atomic nucleus splits into two or more smaller nuclei along with the release of a significant amount of energy?",
      "options": ["Fusion", "Fission", "Decay", "Combustion"],
      "answer_index": 1,
      "level": "Hard"
    },
    {
      "id": 156,
      "question":
          "What is the phenomenon where an object appears to change position against a distant background when viewed from two different positions?",
      "options": ["Interference", "Diffraction", "Refraction", "Parallax"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 157,
      "question":
          "What is the force of attraction between any two masses in the universe?",
      "options": [
        "Electromagnetic force",
        "Gravitational force",
        "Nuclear force",
        "Centrifugal force"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 158,
      "question": "What is the SI unit of power?",
      "options": ["Joule", "Watt", "Newton", "Ampere"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 159,
      "question":
          "What is the phenomenon where light waves reinforce each other or cancel each other out when they interact?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 160,
      "question":
          "What law states that the pressure of a gas is inversely proportional to its volume at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 161,
      "question":
          "What is the measure of the degree of hotness or coldness of an object?",
      "options": ["Temperature", "Heat", "Thermal conductivity", "Entropy"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 162,
      "question":
          "What law of motion states that an object at rest will stay at rest, and an object in motion will stay in motion unless acted upon by an external force?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 163,
      "question":
          "What is the term for the maximum displacement of a vibrating system from its equilibrium position?",
      "options": ["Amplitude", "Frequency", "Wavelength", "Phase"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 164,
      "question":
          "What is the process of converting a solid directly into a gas called?",
      "options": ["Evaporation", "Sublimation", "Condensation", "Vaporization"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 165,
      "question": "What is the SI unit of electric charge?",
      "options": ["Coulomb", "Volt", "Ampere", "Ohm"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 166,
      "question":
          "What type of mirror curves outward and forms a virtual image that is smaller than the object?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 167,
      "question":
          "What is the process by which energy is transferred as heat through a material without any movement of the material itself?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 168,
      "question": "What is the SI unit of frequency?",
      "options": ["Hertz", "Watt", "Joule", "Newton"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 169,
      "question": "What does the term 'quantum' refer to in quantum mechanics?",
      "options": [
        "A unit of energy",
        "A subatomic particle",
        "A discrete quantity of matter",
        "A fundamental aspect of light"
      ],
      "answer_index": 2,
      "level": "Hard"
    },
    {
      "id": 170,
      "question":
          "What is the bending of light waves around obstacles or edges called?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 171,
      "question":
          "What law states that the volume of a given mass of gas is directly proportional to its absolute temperature at constant pressure?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 172,
      "question":
          "What is the process by which a gas changes directly into a solid without passing through the liquid state?",
      "options": ["Deposition", "Sublimation", "Condensation", "Evaporation"],
      "answer_index": 0,
      "level": "Hard"
    },
    {
      "id": 173,
      "question":
          "What is the principle that states that a fluid in equilibrium within a container exerts pressure equally in all directions?",
      "options": [
        "Bernoulli's principle",
        "Archimedes' principle",
        "Pascal's principle",
        "Newton's principle"
      ],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 174,
      "question":
          "What is the name of the subatomic particles that have no electric charge and contribute to the mass of an atom?",
      "options": ["Protons", "Neutrons", "Electrons", "Quarks"],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 175,
      "question":
          "What is the process by which an atom or molecule gains energy and moves to a higher energy state?",
      "options": ["Ionization", "Excitation", "Fusion", "Fission"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 176,
      "question":
          "What is the phenomenon where the amplitude of a vibrating system increases when the frequency of its forced vibrations matches its natural frequency?",
      "options": ["Oscillation", "Damping", "Resonance", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 177,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 178,
      "question":
          "What is the process by which an atomic nucleus combines with another nucleus to form a heavier nucleus and release energy?",
      "options": ["Fusion", "Fission", "Decay", "Combustion"],
      "answer_index": 0,
      "level": "Hard"
    },
    {
      "id": 179,
      "question":
          "What is the point in the orbit of a planet where it is closest to the sun?",
      "options": ["Aphelion", "Equinox", "Perihelion", "Solstice"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 180,
      "question":
          "What law of thermodynamics states that heat flows naturally from an object at a higher temperature to an object at a lower temperature?",
      "options": [
        "First law of thermodynamics",
        "Second law of thermodynamics",
        "Third law of thermodynamics",
        "Zeroth law of thermodynamics"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 181,
      "question": "What is the measure of the resistance of a fluid to flow?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 182,
      "question":
          "What is the process of changing a gas into a liquid by cooling it?",
      "options": ["Condensation", "Vaporization", "Sublimation", "Deposition"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 183,
      "question":
          "What type of energy is associated with the motion of particles within an object?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 184,
      "question":
          "What is the process by which heat is transferred through the movement of fluids, resulting in the transfer of energy?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 185,
      "question":
          "What is the name for the lowest energy state of an atom or molecule?",
      "options": [
        "Ground state",
        "Excited state",
        "Ionized state",
        "Quantum state"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 186,
      "question":
          "What type of mirror curves inward and forms a virtual image that is larger than the object?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 187,
      "question":
          "What law of motion states that the rate of change of momentum of an object is directly proportional to the applied force and occurs in the direction of the force?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 188,
      "question":
          "What is the term for the process of separating a mixture based on the different speeds at which its components move through a medium?",
      "options": [
        "Filtration",
        "Distillation",
        "Chromatography",
        "Evaporation"
      ],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 189,
      "question":
          "What is the energy possessed by a body due to its motion called?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 1,
      "level": "Easy"
    },
    {
      "id": 190,
      "question": "What does the term 'quantum' refer to in quantum mechanics?",
      "options": [
        "A unit of energy",
        "A subatomic particle",
        "A discrete quantity of matter",
        "A fundamental aspect of light"
      ],
      "answer_index": 2,
      "level": "Hard"
    },
    {
      "id": 191,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 192,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 193,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 194,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 195,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 196,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 197,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 198,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 199,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 200,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 201,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 202,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 203,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 204,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 205,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 206,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 207,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 208,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 209,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 210,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 211,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 212,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 213,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 214,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 215,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 216,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 217,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 218,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 219,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 220,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 221,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 222,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 223,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 224,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 225,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 226,
      "question":
          "What is the process by which energy is transferred from a hotter object to a colder object through direct contact?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 227,
      "question":
          "What is the term for the angle of incidence at which light is no longer reflected but passes from one medium to another?",
      "options": [
        "Angle of reflection",
        "Critical angle",
        "Angle of incidence",
        "Refraction angle"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 228,
      "question": "What is the SI unit of frequency?",
      "options": ["Hertz", "Watt", "Joule", "Newton"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 229,
      "question":
          "What is the phenomenon where an object oscillates at its natural frequency when subjected to an external force with the same frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 230,
      "question":
          "What is the term for the process of converting a solid directly into a gas without passing through the liquid phase?",
      "options": ["Evaporation", "Sublimation", "Condensation", "Vaporization"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 231,
      "question":
          "What is the force that opposes the relative motion or tendency of such motion of two surfaces in contact?",
      "options": ["Friction", "Gravity", "Tension", "Inertia"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 232,
      "question":
          "What law of motion states that the rate of change of momentum of an object is directly proportional to the applied force and occurs in the direction of the force?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 233,
      "question":
          "What is the process by which an atom or molecule gains energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 234,
      "question":
          "What is the term for the total amount of energy possessed by an object due to its motion and position?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 235,
      "question":
          "What is the principle that states that a fluid in equilibrium within a container exerts pressure equally in all directions?",
      "options": [
        "Bernoulli's principle",
        "Archimedes' principle",
        "Pascal's principle",
        "Newton's principle"
      ],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 236,
      "question":
          "What is the process by which a solid changes directly into a gas without going through the liquid phase?",
      "options": ["Evaporation", "Sublimation", "Condensation", "Vaporization"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 237,
      "question":
          "What law of thermodynamics states that energy cannot be created or destroyed, only transferred or converted from one form to another?",
      "options": [
        "First law of thermodynamics",
        "Second law of thermodynamics",
        "Third law of thermodynamics",
        "Zeroth law of thermodynamics"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 238,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 239,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 240,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 241,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 242,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 242,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 243,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 244,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 245,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 246,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 247,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 248,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 249,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 250,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 251,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 252,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 253,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 254,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 255,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 256,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 257,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 258,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 259,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 260,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 261,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 262,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 262,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 263,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 264,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 265,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 266,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 267,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 268,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 269,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 270,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 271,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 272,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 273,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 274,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 275,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 276,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 277,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 278,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 279,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 280,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 281,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 282,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 283,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 284,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 285,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 286,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 287,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 288,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 289,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 290,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 291,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 292,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 293,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 294,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 295,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 296,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 297,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 298,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 299,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 300,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 301,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 302,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 302,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 303,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 304,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 305,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 306,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 307,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 308,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 309,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 310,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 311,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 312,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 313,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 314,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 315,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 316,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 317,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 318,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 319,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 320,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 321,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 322,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 323,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 324,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 325,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 326,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 327,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 328,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 329,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 330,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 331,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 332,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 333,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 334,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 335,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 336,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 337,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 338,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 339,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 340,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 341,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 342,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    // ... Previous questions

    {
      "id": 344,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 345,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 346,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 347,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 348,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 349,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 350,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 351,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 352,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 353,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 354,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 355,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 356,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 357,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 358,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 359,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 360,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 361,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 362,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 363,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 364,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    // ... Previous questions

    {
      "id": 365,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 366,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 367,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 368,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 369,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 370,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 371,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 372,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 373,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 374,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 375,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 376,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 377,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 378,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 379,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 380,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 381,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 382,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 383,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 384,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 385,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },

    // ... Previous questions

    {
      "id": 386,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 387,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 388,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 389,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 390,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 391,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 392,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 393,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 394,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 395,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 396,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 397,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 398,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 399,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 400,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 401,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 402,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 403,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 404,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 405,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 406,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },

    // ... Previous questions

    {
      "id": 406,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 407,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 408,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 409,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 410,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 411,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 412,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 413,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 414,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 415,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 416,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 417,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 418,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 419,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 420,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 421,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 422,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 423,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 424,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 425,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 426,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },

    // ... Previous questions

    {
      "id": 427,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 428,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 429,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 430,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 431,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 432,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 433,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 434,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 435,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 436,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 437,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 438,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 439,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 440,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 441,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 442,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 443,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 444,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 445,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 446,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 447,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },

    // ... Previous questions

    {
      "id": 447,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 448,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 449,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 450,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 451,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 452,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 453,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 454,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 455,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 456,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 457,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 458,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 459,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 460,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 461,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 462,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 463,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 464,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 465,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 466,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 467,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },

    // ... Previous questions

    {
      "id": 468,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 469,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 470,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 471,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 472,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 473,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 474,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 475,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 476,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 477,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 478,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 479,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 480,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 481,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 482,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 483,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 484,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 485,
      "question":
          "What is the process by which heat is transferred through electromagnetic waves?",
      "options": ["Conduction", "Convection", "Radiation", "Sublimation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 486,
      "question":
          "What is the term for the force exerted per unit area by a fluid?",
      "options": ["Pressure", "Density", "Viscosity", "Surface tension"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 487,
      "question":
          "What is the process of converting a liquid into a gas at a temperature below its boiling point?",
      "options": ["Vaporization", "Boiling", "Evaporation", "Condensation"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 488,
      "question":
          "What is the phenomenon where a vibrating object causes another object to vibrate at its natural frequency?",
      "options": ["Amplification", "Resonance", "Interference", "Diffraction"],
      "answer_index": 1,
      "level": "Medium"
    },

    // ... Previous questions

    {
      "id": 489,
      "question":
          "What type of mirror forms a virtual, upright, and diminished image?",
      "options": [
        "Concave mirror",
        "Convex mirror",
        "Plane mirror",
        "Spherical mirror"
      ],
      "answer_index": 1,
      "level": "Medium"
    },
    {
      "id": 490,
      "question":
          "What law states that the volume of a given mass of gas is inversely proportional to its pressure at constant temperature?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 491,
      "question":
          "What is the process by which an atom or molecule loses energy and transitions to a lower energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Relaxation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 492,
      "question":
          "What is the term for the measure of disorder or randomness in a system?",
      "options": ["Entropy", "Temperature", "Pressure", "Kinetic energy"],
      "answer_index": 0,
      "level": "Medium"
    },
    {
      "id": 493,
      "question":
          "What is the phenomenon where light waves are split into different colors or wavelengths as they pass through a prism?",
      "options": ["Diffraction", "Interference", "Refraction", "Dispersion"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 494,
      "question": "What is the SI unit of electric current?",
      "options": ["Coulomb", "Ohm", "Ampere", "Volt"],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 495,
      "question":
          "What law states that the pressure of a gas is directly proportional to its temperature at constant volume?",
      "options": [
        "Boyle's law",
        "Charles's law",
        "Avogadro's law",
        "Gay-Lussac's law"
      ],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 496,
      "question":
          "What is the process by which an atom or molecule absorbs energy and transitions to a higher energy state?",
      "options": ["Ionization", "Decay", "Fusion", "Excitation"],
      "answer_index": 3,
      "level": "Medium"
    },
    {
      "id": 497,
      "question":
          "What law of motion states that for every action, there is an equal and opposite reaction?",
      "options": [
        "Newton's First Law",
        "Newton's Second Law",
        "Newton's Third Law",
        "Law of Gravitation"
      ],
      "answer_index": 2,
      "level": "Easy"
    },
    {
      "id": 498,
      "question":
          "What is the phenomenon where light waves reinforce each other to produce regions of greater intensity?",
      "options": ["Reflection", "Refraction", "Interference", "Diffraction"],
      "answer_index": 2,
      "level": "Medium"
    },
    {
      "id": 499,
      "question": "What is the SI unit of magnetic field strength?",
      "options": ["Tesla", "Ohm", "Hertz", "Ampere"],
      "answer_index": 0,
      "level": "Easy"
    },
    {
      "id": 500,
      "question":
          "What type of energy does an object possess due to its position or condition?",
      "options": [
        "Potential energy",
        "Kinetic energy",
        "Mechanical energy",
        "Thermal energy"
      ],
      "answer_index": 0,
      "level": "Easy"
    },
    // Add more questions here...
  ];

  // called immediately after the widget is allocated memory
  @override
  void onInit() async {
    print(_questions);
    _pageController = PageController();
    // Our animation duration is 60 s
    // so our plan is to fill the progress bar within 60s
    _animationController =
        AnimationController(duration: Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // update like setState
        update();
      });

    // start our animation
    _animationController.forward().whenComplete(nextQuestion);

    // Once 60s is completed go to the next qn
    await fetchQuestionsByLevel(level);


    print(_questions);
    super.onInit();
  }

  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
    super.onClose();
    // Clear the questions list

    _animationController.dispose();
    _pageController.dispose();
  }

  void addMCQData() {
    for (var mcqData in sample_data) {
      _databaseReference.push().set(mcqData);
    }
  }

  Future<void> fetchQuestions1() async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    database.child('physics_mcqs').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, questionData) {
          _questions.add(Question(
            id: questionData['id'],
            question: questionData['question'],
            options: List<String>.from(questionData['options']),
            answer: questionData['answer_index'],
          ));
        });
        _questions.shuffle();
      }
    }).catchError((error) {
      // Handle error
      print("Error fetching questions: $error");
    });
  }

  void clearList() {
    _questions.clear();
  }

  Future<void> fetchQuestionsByLevel(String level) async {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    database.child('physics_mcqs').once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, questionData) {
          String questionLevel = questionData['level'];

          if (questionLevel == level) {
            _questions.add(Question(
              id: questionData['id'],
              question: questionData['question'],
              options: List<String>.from(questionData['options']),
              answer: questionData['answer_index'],
            ));
          }
        });

        _questions.shuffle();
        // Now you can do something with the filtered and shuffled questions.
      }
    }).catchError((error) {
      // Handle error
      print("Error fetching questions: $error");
    });
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) {
      _numOfCorrectAns++;

      print(numOfCorrectAns);
    }
    ;

    // It will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_questionNumber.value != 5) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
  
      print(numOfCorrectAns);
      Get.to(ScoreScreen(
        level: level,
      ));

      // Get package provide us simple way to naviigate another page
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}
