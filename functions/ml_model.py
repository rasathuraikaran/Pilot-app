import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score

def train_and_predict(question):
    data = pd.read_csv('physics_questions.csv')

    X = data['Question']
    y = data['Level']

    tfidf_vectorizer = TfidfVectorizer()
    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
    X_train_tfidf = tfidf_vectorizer.fit_transform(X_train)

    classifier = MultinomialNB()
    classifier.fit(X_train_tfidf, y_train)

    unseen_question_tfidf = tfidf_vectorizer.transform([question])
    predicted_level = classifier.predict(unseen_question_tfidf)[0]

    return predicted_level
